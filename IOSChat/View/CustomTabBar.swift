//
//  CustomTabBar.swift
//  IOSChat
//
//  Created by Kurs on 26/02/2021.
//

import UIKit

class CustomTabBar: UITabBar {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addTabBarShadow()
    }

    func addTabBarShadow() {
        self.layoutIfNeeded()
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        self.barTintColor = #colorLiteral(red: 0.8, green: 0.9490196078, blue: 0.9568627451, alpha: 1)
    }
}
