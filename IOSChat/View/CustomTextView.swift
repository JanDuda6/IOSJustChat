//
//  CustomTextView.swift
//  IOSChat
//
//  Created by Kurs on 22/03/2021.
//

import Foundation
import UIKit

class CustomTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        checkIfTextContainsURL()
    }

    func checkIfTextContainsURL() {
        let message = self.text!
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: message, options: [], range: NSRange(location: 0, length: message.utf16.count))

        if matches.count > 0 {
            for match in matches {
                guard let range = Range(match.range, in: message) else { continue }
                var url = message[range]
                let link = (message as NSString).range(of: String(url))
                let attributedString = NSMutableAttributedString(string: message)

                if !url.hasPrefix("https://") {
                    url = Substring("https://" + url)
                    attributedString.addAttribute(.link, value: url, range: link)
                } else {
                    attributedString.addAttribute(.link, value: url, range: link)
                }
                self.attributedText = attributedString
                self.font = UIFont.systemFont(ofSize: 14)
            }
        } else {
            self.text = message
        }
    }
}
