//
//  CustomChatView.swift
//  IOSChat
//
//  Created by Kurs on 01/03/2021.
//

import UIKit

class CustomChatView: UIView {
    override func layoutSubviews() {
        addShadow()
    }

    func addShadow() {
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }
}
