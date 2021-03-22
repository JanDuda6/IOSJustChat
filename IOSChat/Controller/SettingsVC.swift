//
//  SettingsVC.swift
//  IOSChat
//
//  Created by Kurs on 04/02/2021.
//

import Foundation
import UIKit

class SettingsVC: KeyboardHandlerVC, UINavigationControllerDelegate {
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet weak var changeNameTextField: CustomTextField!
    @IBOutlet weak var changeEmailTextField: CustomTextField!
    @IBOutlet weak var changePassword: CustomTextField!
    let userService = UserService()

    @IBAction func changeUserImageButtonPressed(_ sender: UIButton) {
        photoActionSheet()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userService.loadUserImage(contactUserID: "") { (image) in
            self.userImage.image = image
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if let password = changePassword.text {
            userService.updateUserPassword(with: password, viewController: self)
        } 
        if let name = changeNameTextField.text {
            userService.updateUserName(with: name, viewController: self)
        }
        if let email = changeEmailTextField.text {
            userService.updateUserEmail(with: email, viewController: self)
        }
        changePassword.text = ""
        changeNameTextField.text = ""
        changeEmailTextField.text = ""
    }
}

//MARK: - Change image action sheet
extension SettingsVC {

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

//MARK: - Image Picker Delegate
extension SettingsVC: UIImagePickerControllerDelegate {

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
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        userImage.image = image
        userService.setUserImage(userImage: userImage.image!)
        self.dismiss(animated: true, completion: nil)
    }
}
