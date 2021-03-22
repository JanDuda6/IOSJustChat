//
//  Message.swift
//  IOSChat
//
//  Created by Kurs on 13/11/2020.
//

import Foundation
import UIKit

struct Message {
    let sender: String
    let senderID: String
    let body: String
    let date: Date
    let imageMessage: Bool
    var imageURL = ""

    func toDictionary() -> [String : Any] {
        return ["sender" : sender, "senderID" : senderID, "body" : body, "date" : date, "imageURL" : imageURL, "imageMessage" : imageMessage]
    }
}
