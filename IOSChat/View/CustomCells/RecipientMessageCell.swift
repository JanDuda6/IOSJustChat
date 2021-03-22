//
//  SenderMessageCell.swift
//  IOSChat
//
//  Created by Kurs on 03/02/2021.
//

import UIKit

class RecipientMessageCell: UITableViewCell {
    @IBOutlet private weak var messageBody: UIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var contactImage: UIImageView!
    @IBOutlet private weak var messageText: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        messageBody.layer.cornerRadius = messageBody.frame.height * 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func messageFilling(date: Date, body: String, image: UIImage) {
        self.messageText.text = body
        self.dateLabel.text = DateFormat.dateFormat(date: date)
        self.contactImage.image = image
    }
}
