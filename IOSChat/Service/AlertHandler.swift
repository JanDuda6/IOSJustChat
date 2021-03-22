//
//  AlertController.swift
//  IOSChat
//
//  Created by Kurs on 17/11/2020.
//

import UIKit

struct AlertHandler {

    static func errorHandler(view: UIViewController, error: Error) {
        let alertController = UIAlertController(title: Constant.AlertMessages.error, message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constant.AlertMessages.ok, style: .default, handler: nil))
        view.present(alertController, animated: true, completion: nil)
    }
    
    static func errorHandler(view: UIViewController, errorMessage: String) {
        let alertController = UIAlertController(title: Constant.AlertMessages.error, message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constant.AlertMessages.ok, style: .default, handler: nil))
        view.present(alertController, animated: true, completion: nil)
    }

    static func updateSuccessHandler(view: UIViewController, message: String) {
        let alertController = UIAlertController(title: Constant.AlertMessages.success, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constant.AlertMessages.ok, style: .default, handler: nil))
        view.present(alertController, animated: true, completion: nil)
    }
}
