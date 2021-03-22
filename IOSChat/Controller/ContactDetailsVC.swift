//
//  ContactDetails.swift
//  IOSChat
//
//  Created by Kurs on 02/03/2021.
//

import Foundation
import UIKit

class ContactDetailsVC: KeyboardHandlerVC {
    @IBOutlet private weak var contactImageView: CustomImage!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var nameTextField: CustomTextField!

    let contactService = ContactService()
    let roomService = RoomService()
    var contactImage = UIImage()
    var userContact = User()
    var roomDetails = RoomDetails()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = userContact.name
        contactImageView.image = userContact.photo
        emailLabel.text = userContact.email
        nameTextField.text = userContact.name
    }

    @IBAction func messagesButtonPressed(_ sender: UIButton) {
        roomDetails.userEmail = userContact.email
        roomDetails.userID = userContact.userID
        roomDetails.userName = userContact.name
        roomDetails.userImage = userContact.photo
        roomService.searchForRoomID(contactUserID: userContact.userID) { [self] (roomID) in
            roomDetails.roomID = roomID
            performSegue(withIdentifier: Constant.SegueIdentifier.chatSegue, sender: self)
        }
    }

    @IBAction func updateContactData(_ sender: UIButton) {
        let name = nameTextField.text
        if name != "" {
            contactService.updateContactName(contactID: userContact.userID, contactNewName: name!)
            self.title = name
            nameTextField.text = name
            nameTextField.endEditing(true)
            userContact.name = name!
        } else {
            AlertHandler.errorHandler(view: self, errorMessage: Constant.AlertMessages.emptyName)
            nameTextField.endEditing(true)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.SegueIdentifier.chatSegue {
            if let chatVC = segue.destination as? ChatVC {
                chatVC.roomDetails = roomDetails
            }
        }
    }
}
