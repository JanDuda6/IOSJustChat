//
//  Room.swift
//  IOSChat
//
//  Created by Kurs on 27/01/2021.
//

import Foundation

struct Room {
    let createDate: Date
    let members: [String : Bool]

    func toDictionary() -> [String : Any] {
        return ["createDate" : createDate, "members" : members]
    }
}
