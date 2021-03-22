//
//  AddContactVC.swift
//  IOSChat
//
//  Created by Kurs on 19/11/2020.
//

import UIKit
import Firebase

class AddContactVC: UIViewController {
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var nameTextField: UITextField!

    let contactService = ContactService()
    var contactEmail = ""

    override func viewDidLoad() {
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)
        super.viewDidLoad()
        emailTextFieldSetUp()
    }

    @IBAction func addButtonPushed(_ sender: UIButton) {
        if nameTextField.text == "" {
            AlertHandler.errorHandler(view: self, errorMessage: Constant.AlertMessages.emptyName)
            return
        }
        if emailTextField.text == "" {
            AlertHandler.errorHandler(view: self, errorMessage: Constant.AlertMessages.emptyEmail)
            return
        }
        contactService.addFriendToContactList(contactEmail: emailTextField.text!, contactName: nameTextField.text!, viewController: self)
        emailTextField.endEditing(true)
        nameTextField.endEditing(true)
    }

    func emailTextFieldSetUp() {
        if contactEmail == "" {
            emailTextField.isEnabled = true
        } else {
            emailTextField.text = contactEmail
            emailTextField.isEnabled = false
        }
    }
}
