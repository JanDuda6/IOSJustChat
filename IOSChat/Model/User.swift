//
//  User.swift
//  IOSChat
//
//  Created by Kurs on 08/01/2021.
//

import Foundation
import UIKit

struct User {
    var email: String
    var name: String
    var userID: String
    var photo: UIImage

    init() {
        self.email = ""
        self.name = ""
        self.userID = ""
        self.photo = UIImage()
    }

    init(email: String, name: String, userID: String) {
        self.email = email
        self.name = name
        self.userID = userID
        self.photo = UIImage()
    }

    func toDictionary() -> [String : Any] {
        return ["name" : name, "email" : email, "uid" : userID]
    }
}
