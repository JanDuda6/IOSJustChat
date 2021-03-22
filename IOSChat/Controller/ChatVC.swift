//
//  ChatVC.swift
//  IOSChat
//
//  Created by Kurs on 05/01/2021.
//

import Foundation
import UIKit

class ChatVC: KeyboardHandlerVC, UINavigationControllerDelegate {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var addToContactListButton: UIBarButtonItem!

    let chatService = ChatService()
    let contactService = ContactService()
    var roomDetails = RoomDetails()
    var messages = [Message]()
    var imageToSend = UIImage()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = roomDetails.userName
        showAddContactToContactsButton()
        navigationController?.navigationBar.isTranslucent = false
        loadMessage()
        tableView.dataSource = self
        registerTableViewCells()
        chatService.readAndUpdateLastMessage(roomID: roomDetails.roomID)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatService.readAndUpdateLastMessage(roomID: roomDetails.roomID)
    }

    @IBAction func sendPhotoButtonPressed(_ sender: UIButton) {
        photoActionSheet()
    }
    
    @IBAction func addToContactListButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constant.SegueIdentifier.addContactSegue, sender: self)
    }

    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if let messageBody = textView.text {
            chatService.sendMessage(messageBody: messageBody, roomID: roomDetails.roomID, contactUserID: roomDetails.userID, imageMessage: false, imageToSend: nil)
        }
        textView.text = ""
    }

    func loadMessage() {
        chatService.loadMessages(roomID: roomDetails.roomID) { (messagesArray) in
            self.messages = messagesArray
            self.tableView.reloadData()
            if self.messages.count > 0 {
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
            }
        }
    }

    func showAddContactToContactsButton() {
        contactService.searchForUserInContactList(contactUserID: roomDetails.userID) { [self] (user) in
            if user == nil {
                addToContactListButton.isEnabled = true
            } else {
                self.title = user!.name
                addToContactListButton.isEnabled = false
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIdentifier.addContactSegue {
            if let addContactVC = segue.destination as? AddContactVC {
                addContactVC.contactEmail = roomDetails.userEmail
            }
        }
    }
}

//MARK: - TableView data source
extension ChatVC: UITableViewDataSource {

    func registerTableViewCells() {
        tableView.register(UINib(nibName: Constant.CellNamesAndIdentifier.userMessageCell, bundle: nil), forCellReuseIdentifier: Constant.CellNamesAndIdentifier.userMessageCellIdentifier)
        tableView.register(UINib(nibName: Constant.CellNamesAndIdentifier.recipientMessageCell, bundle: nil), forCellReuseIdentifier: Constant.CellNamesAndIdentifier.recipientMessageCellIdentifier)
        tableView.register(UINib(nibName: Constant.CellNamesAndIdentifier.userImageMessageCell, bundle: nil), forCellReuseIdentifier: Constant.CellNamesAndIdentifier.userImageMessageCellIdentifier)
        tableView.register(UINib(nibName: Constant.CellNamesAndIdentifier.recipientImageMessageCell, bundle: nil), forCellReuseIdentifier: Constant.CellNamesAndIdentifier.recipientImageMessageCellIdentifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userCell = tableView.dequeueReusableCell(withIdentifier: Constant.CellNamesAndIdentifier.userMessageCellIdentifier, for: indexPath) as! UserMessageCell
        let recipientCell = tableView.dequeueReusableCell(withIdentifier: Constant.CellNamesAndIdentifier.recipientMessageCellIdentifier, for: indexPath) as! RecipientMessageCell
        let userImageMessageCell = tableView.dequeueReusableCell(withIdentifier: Constant.CellNamesAndIdentifier.userImageMessageCellIdentifier, for: indexPath) as! UserImageMessageCell
        let recipientImageMessageCell = tableView.dequeueReusableCell(withIdentifier: Constant.CellNamesAndIdentifier.recipientImageMessageCellIdentifier, for: indexPath) as! RecipientImageMessageCell

        userImageMessageCell.imageMessage.image = UIImage()
        recipientImageMessageCell.imageMessage.image = UIImage()

        let senderID = messages[indexPath.row].senderID
        let date = messages[indexPath.row].date
        let body = messages[indexPath.row].body
        let imageURL = messages[indexPath.row].imageURL
        let imageMessage = messages[indexPath.row].imageMessage

        if senderID == roomDetails.userID {
            if imageMessage == true {
                DispatchQueue.global().async { [self] in
                    let image = downloadImageFromURL(url: imageURL)
                    DispatchQueue.main.async { [self] in
                        recipientImageMessageCell.messageContent(image: image, date: date, userImage: roomDetails.userImage)
                    }
                }
                return recipientImageMessageCell
            } else {
                recipientCell.messageFilling(date: date, body: body, image: roomDetails.userImage)
                return recipientCell
            }
        } else {
            if imageMessage == true {
                DispatchQueue.global().async { [self] in
                    let image = downloadImageFromURL(url: imageURL)
                    DispatchQueue.main.async {
                        userImageMessageCell.messageContent(image: image, date: date)
                    }
                }
                return userImageMessageCell
            } else {
                userCell.messageCell(date: date, body: body)
                return userCell
            }
        }
    }

    func downloadImageFromURL(url: String) -> UIImage {
        let url = URL(string: url)!
        let imageData = try! Data(contentsOf: url)
        let image = UIImage(data: imageData)
        return image!
    }
}

//MARK: - Image Picker and action sheet
extension ChatVC: UIImagePickerControllerDelegate {

    func showUserPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    func showUserCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        chatService.sendMessage(messageBody: "", roomID: roomDetails.roomID, contactUserID: roomDetails.userID, imageMessage: true, imageToSend: image)
        self.dismiss(animated: true, completion: nil)
    }

    func photoActionSheet() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Constant.AlertMessages.deletePhoto, style: .destructive, handler: nil))

        alertController.addAction(UIAlertAction(title: Constant.AlertMessages.takePhoto, style: .default, handler: { (alert) in
            self.showUserCamera()
        }))

        alertController.addAction(UIAlertAction(title: Constant.AlertMessages.choosePhoto, style: .default, handler: { (alert) in
            self.showUserPhotoLibrary()
        }))

        alertController.addAction(UIAlertAction(title: Constant.AlertMessages.cancel, style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}
