//
//  CustomLabel.swift
//  IOSChat
//
//  Created by Kurs on 02/03/2021.
//

import UIKit

class CustomViewInMessageCell: UIView {
    override func layoutSubviews() {
        setUpShadowAndRoundCorners()
    }

    func setUpShadowAndRoundCorners() {
        let cornerRadius = self.frame.height * 0.5
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOpacity = 0.7
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    }
}
