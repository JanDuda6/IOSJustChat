//
//  KeyboardHandler.swift
//  IOSChat
//
//  Created by Kurs on 17/03/2021.
//

import Foundation
import UIKit

class KeyboardHandlerVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var keyboardHeight: CGFloat = .zero
    var viewHeight: CGFloat = .zero

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
        // fix black bar above keyboard error
        viewHeight = self.view.frame.height
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }

    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {

        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(view.endEditing))
        view.addGestureRecognizer(tapGesture)

        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardHeight = keyboardSize.height

        if let scrollview = scrollView {
            scrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + keyboardHeight)
        } else {
            self.view.frame.origin.y = 0 - keyboardHeight
            self.view.frame.size.height = viewHeight
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let scrollview = scrollView {
            scrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height - keyboardHeight)
        } else {
            self.view.frame.origin.y = 0
            self.view.frame.size.height = viewHeight
        }
    }
}
