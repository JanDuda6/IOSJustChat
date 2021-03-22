//
//  UserImageMessageCell.swift
//  IOSChat
//
//  Created by Kurs on 12/03/2021.
//

import UIKit

class UserImageMessageCell: UITableViewCell {
    @IBOutlet weak var imageMessage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageMessage.image = UIImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func messageContent(image: UIImage, date: Date) {
        self.imageMessage.image = image
        self.imageMessage.layer.cornerRadius = imageMessage.frame.height * 0.2
        self.dateLabel.text = DateFormat.dateFormat(date: date)
    }
}
