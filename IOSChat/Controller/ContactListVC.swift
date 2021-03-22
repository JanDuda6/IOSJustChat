//
//  ContactListVC.swift
//  IOSChat
//
//  Created by Kurs on 17/11/2020.
//

import Foundation
import Firebase
import UIKit

class ContactListVC: UITableViewController {
    let contactService = ContactService()
    let roomService = RoomService()
    let userService = UserService()
    var contactList = [User]()
    var filteredContactList = [User]()
    var userContact = User()
    let searchController = UISearchController()
    var isContactListFiltered = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        tableView.reloadData()
        loadContactList()
        tableView.register(UINib(nibName: Constant.CellNamesAndIdentifier.contactCell, bundle: nil), forCellReuseIdentifier: Constant.CellNamesAndIdentifier.contactCellIdentifier)
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }

    @IBAction func showAddContactVC(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constant.SegueIdentifier.addContactVC, sender: self)
    }
    
    func loadContactList() {
        self.contactService.loadContactList { (contactArray) in
            self.contactList = contactArray
            self.tableView.reloadData()
        }
    }
}

//MARK: - table View
extension ContactListVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isContactListFiltered == true {
            return filteredContactList.count
        } else {
            return contactList.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var contactCellFilling = User()
        if isContactListFiltered == true {
            contactCellFilling = fillContactCell(contactList: filteredContactList, indexPath: indexPath)
        } else {
            contactCellFilling = fillContactCell(contactList: contactList, indexPath: indexPath)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.CellNamesAndIdentifier.contactCellIdentifier, for: indexPath) as! ContactCell
        userService.loadUserImage(contactUserID: contactCellFilling.userID) { (image) in
            contactCellFilling.photo = image
            cell.contactCellFilling(user: contactCellFilling)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isContactListFiltered == true {
            fillUserStruct(contactList: filteredContactList, indexPath: indexPath)
        } else {
            fillUserStruct(contactList: contactList, indexPath: indexPath)
        }
    }
    
    func fillUserStruct(contactList: [User], indexPath: IndexPath) {
        userContact.email = contactList[indexPath.row].email
        userContact.userID = contactList[indexPath.row].userID
        userContact.name = contactList[indexPath.row].name
        DispatchQueue.global().async { [self] in
            userService.loadUserImage(contactUserID: userContact.userID) { [self] (image) in
                DispatchQueue.main.async {
                    userContact.photo = image
                    roomService.checkIfRoomExists(with: userContact.userID)
                    performSegue(withIdentifier: Constant.SegueIdentifier.contactDetailsVC, sender: self)
                }
            }
        }
    }

    func fillContactCell(contactList: [User], indexPath: IndexPath) -> User {
        var contactCellFilling = User()
        contactCellFilling.userID = contactList[indexPath.row].userID
        contactCellFilling.name = contactList[indexPath.row].name
        contactCellFilling.email = contactList[indexPath.row].email
        return contactCellFilling
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIdentifier.contactDetailsVC {
            if let contactDetailsVC = segue.destination as? ContactDetailsVC {
                contactDetailsVC.userContact = userContact
            }
        }
    }
}

//MARK: - SearchBar Delegate
extension ContactListVC: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == false {
            filteredContactList = contactList.filter({$0.name.lowercased().contains(searchText.lowercased())})
            tableView.reloadData()
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isContactListFiltered = true
        filteredContactList = contactList
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isContactListFiltered = false
        tableView.reloadData()
    }
}
