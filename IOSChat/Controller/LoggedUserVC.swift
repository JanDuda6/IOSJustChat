//
//  File.swift
//  IOSChat
//
//  Created by Kurs on 13/11/2020.
//

import UIKit
import Firebase

class LoggedUserVC: UITableViewController {
    let userService = UserService()
    let roomService = RoomService()
    var roomList = [RoomDetails]()
    var roomDetails = RoomDetails()
    var filteredRoomList = [RoomDetails]()
    let searchController = UISearchController()
    var isRoomListFiltered = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        tableView.register(UINib(nibName: Constant.CellNamesAndIdentifier.chatListCell, bundle: nil), forCellReuseIdentifier: Constant.CellNamesAndIdentifier.chatListCellIdentifier)
        loadUserRooms()
    }

    func loadUserRooms() {
        roomService.loadUserRooms { [self] (roomDetailsArray) in
            roomList = roomDetailsArray
            tableView.reloadData()
        }
    }

    @IBAction func newChatButtonPushed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constant.SegueIdentifier.newChatWindow, sender: self)
    }

    @IBAction func logOutButtonPushed(_ sender: UIBarButtonItem) {
        self.navigationController?.navigationController?.popToRootViewController(animated: true)
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("\(Constant.ErrorDescription.LogOutError): \(signOutError)")
        }
    }
}

//MARK: - Table view
extension LoggedUserVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRoomListFiltered == true {
            return filteredRoomList.count
        } else {
            return roomList.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellNamesAndIdentifier.chatListCellIdentifier, for: indexPath) as! ChatListCell
        var roomDetailsCell = RoomDetails()
        if isRoomListFiltered == false {
            roomDetailsCell = fillRoomDetailsCell(roomList: roomList, indexPath: indexPath)
        } else {
            roomDetailsCell = fillRoomDetailsCell(roomList: filteredRoomList, indexPath: indexPath)

        }
        if roomDetailsCell.lastMessageBody == "" {
            roomDetailsCell.lastMessageBody = "PHOTO"
        }
        userService.loadUserImage(contactUserID: roomDetailsCell.userID) { (image) in
            roomDetailsCell.userImage = image
            cell.chatListCellFilling(roomDetails: roomDetailsCell)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isRoomListFiltered == true {
            fillRoomDetailsStruct(roomList: filteredRoomList, indexPath: indexPath)
        } else {
            fillRoomDetailsStruct(roomList: roomList, indexPath: indexPath)
        }
    }

    func fillRoomDetailsStruct(roomList: [RoomDetails], indexPath: IndexPath) {
        roomDetails.userEmail = roomList[indexPath.row].userEmail
        roomDetails.userID = roomList[indexPath.row].userID
        roomDetails.userName = roomList[indexPath.row].userName
        roomDetails.roomID = roomList[indexPath.row].roomID
        DispatchQueue.global().async { [self] in
            userService.loadUserImage(contactUserID: roomDetails.userID) { [self] (image) in
                DispatchQueue.main.async {
                    roomDetails.userImage = image
                    roomService.checkIfRoomExists(with: roomDetails.userID)
                    performSegue(withIdentifier: Constant.SegueIdentifier.chatVC, sender: self)
                }
            }
        }
    }

    func fillRoomDetailsCell(roomList: [RoomDetails], indexPath: IndexPath) -> RoomDetails {
        var roomDetailsCell = RoomDetails()
        roomDetailsCell.userID = roomList[indexPath.row].userID
        roomDetailsCell.userName = roomList[indexPath.row].userName
        roomDetailsCell.lastMessageBody = roomList[indexPath.row].lastMessageBody
        roomDetailsCell.lastMessageCreateDate = roomList[indexPath.row].lastMessageCreateDate
        roomDetailsCell.lastMessageRead = roomList[indexPath.row].lastMessageRead
        return roomDetailsCell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIdentifier.chatVC {
            if let chatVC = segue.destination as? ChatVC {
                chatVC.roomDetails = roomDetails
            }
        }
    }
}

//MARK: - SearchBar Delegate
extension LoggedUserVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            filteredRoomList = roomList.filter({$0.userName.lowercased().contains(searchText.lowercased())})
            tableView.reloadData()
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isRoomListFiltered = true
        filteredRoomList = roomList
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isRoomListFiltered = false
        tableView.reloadData()
    }
}
