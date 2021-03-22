//
//  CustomTextField.swift
//  IOSChat
//
//  Created by Kurs on 15/02/2021.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
      override func layoutSubviews() {
          super.layoutSubviews()
          setUpTextField()
      }

    func setUpTextField() {
        let cornerRadius = self.frame.height * 0.5
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 5
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
    }
}
