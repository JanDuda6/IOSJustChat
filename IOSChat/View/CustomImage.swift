//
//  CustomImage.swift
//  IOSChat
//
//  Created by Kurs on 15/02/2021.
//

import Foundation
import UIKit

class CustomImage: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height * 0.5
        self.clipsToBounds = true
    }
}
