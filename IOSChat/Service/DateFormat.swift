//
//  DateFormat.swift
//  IOSChat
//
//  Created by Kurs on 18/03/2021.
//

import Foundation

struct DateFormat {
    static func dateFormat(date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = Constant.CustomElements.dateFormat
        return format.string(from: date)
    }
}
