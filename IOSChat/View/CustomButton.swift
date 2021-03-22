//
//  CustomButton.swift
//  IOSChat
//
//  Created by Kurs on 15/02/2021.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    let gradient = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buttonSetup()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = self.frame.height * 0.5
        self.gradient.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.gradient.frame = bounds
    }

    func buttonSetup() {
        self.titleLabel?.font = UIFont(name: Constant.CustomElements.buttonFont, size: 15)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        self.backgroundColor = nil
        self.layoutIfNeeded()
        gradientButtonColor()
    }

    func gradientButtonColor() {
        var firstColor: CGColor
        var lastColor: CGColor
        let cornerRadius = self.frame.height * 0.5

        switch self.titleLabel?.text {
        case Constant.CustomElements.googleButton:
            firstColor = #colorLiteral(red: 1, green: 0.2549019608, blue: 0.4235294118, alpha: 1).cgColor
            lastColor = #colorLiteral(red: 1, green: 0.2941176471, blue: 0.168627451, alpha: 1).cgColor
            self.gradient.colors = [firstColor, lastColor]

        case Constant.CustomElements.createAccountButton:
            firstColor = #colorLiteral(red: 0.8666666667, green: 0.368627451, blue: 0.537254902, alpha: 1).cgColor
            lastColor = #colorLiteral(red: 0.968627451, green: 0.7333333333, blue: 0.5921568627, alpha: 1).cgColor
            self.gradient.colors = [firstColor, lastColor]

        case Constant.CustomElements.logInButton:
            firstColor = #colorLiteral(red: 1, green: 0.4941176471, blue: 0.3725490196, alpha: 1).cgColor
            lastColor = #colorLiteral(red: 0.9960784314, green: 0.7058823529, blue: 0.4823529412, alpha: 1).cgColor
            self.gradient.colors = [firstColor, lastColor]

        default:
            firstColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.8588235294, alpha: 1).cgColor
            lastColor = #colorLiteral(red: 0, green: 0.5137254902, blue: 0.6901960784, alpha: 1).cgColor
            self.gradient.colors = [firstColor, lastColor]
        }

        self.gradient.startPoint = CGPoint(x: 0, y: 0)
        self.gradient.endPoint = CGPoint(x: 1, y: 0)
        self.gradient.cornerRadius = cornerRadius
        self.gradient.borderColor = UIColor.lightGray.cgColor
        self.gradient.borderWidth = 1
        self.gradient.shadowOpacity = 0.7
        self.gradient.shadowColor = UIColor.lightGray.cgColor
        self.gradient.shadowOffset = .zero
        self.gradient.shadowRadius = 5
        self.layer.insertSublayer(gradient, at: 0)
    }
}
