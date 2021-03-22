//
//  CustoomView.swift
//  IOSChat
//
//  Created by Kurs on 01/03/2021.
//

import UIKit

class CustomChatCellView: UIView {
    override func layoutSubviews() {
        setShadowAndCornerRadius()
    }

    func setShadowAndCornerRadius() {
        let cornerRadius = self.frame.height * 0.2
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOffset = .zero
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
}
