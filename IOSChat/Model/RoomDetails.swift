//
//  RoomAndUser.swift
//  IOSChat
//
//  Created by Kurs on 05/02/2021.
//

import Foundation
import UIKit

struct RoomDetails {
    var userName: String
    var userEmail: String
    var userID: String
    var userImage: UIImage
    var lastMessageBody: String
    var lastMessageCreateDate: Date
    var lastMessageSender: String
    var lastMessageRead: Bool
    var roomID: String

    init() {
        self.userName = ""
        self.userEmail = ""
        self.userID = ""
        self.userImage = UIImage()
        self.lastMessageBody = ""
        self.lastMessageCreateDate = Date()
        self.lastMessageSender = ""
        self.lastMessageRead = false
        self.roomID = ""
    }

    init(userName: String, userEmail: String, userID: String) {
        self.userName = userName
        self.userEmail = userEmail
        self.userID = userID
        self.userImage = UIImage()
        self.lastMessageBody = ""
        self.lastMessageCreateDate = Date()
        self.lastMessageSender = ""
        self.lastMessageRead = true
        self.roomID = ""
    }
    
    func toDictionary() -> [String : Any] {
        return ["name" : userName, "email" : userEmail, "uid" : userID]
    }
}
