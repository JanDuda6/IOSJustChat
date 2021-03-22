//
//  TableViewCell.swift
//  IOSChat
//
//  Created by Kurs on 29/01/2021.
//

import UIKit

class UserMessageCell: UITableViewCell {
    @IBOutlet private weak var messageBody: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var messageText: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        messageBody.layer.cornerRadius = messageBody.frame.height * 0.2
        messageBody.backgroundColor = #colorLiteral(red: 0.5182167888, green: 0.8161244988, blue: 0.7726516128, alpha: 1)
        messageText.backgroundColor = #colorLiteral(red: 0.5182167888, green: 0.8161244988, blue: 0.7726516128, alpha: 1)
        dateLabel.textAlignment = .right
        self.messageText.layer.cornerRadius = self.messageText.frame.height * 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func messageCell(date: Date, body: String) {
        self.dateLabel.text = DateFormat.dateFormat(date: date)
        self.messageBody.isHidden = false
        self.messageText.isHidden = false
        self.messageText.text = body
    }
}
