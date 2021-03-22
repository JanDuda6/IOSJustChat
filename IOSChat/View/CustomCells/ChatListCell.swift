//
//  ChatListCell.swift
//  IOSChat
//
//  Created by Kurs on 05/02/2021.
//

import UIKit

class ChatListCell: UITableViewCell {    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var lastMessageLabel: UILabel!
    @IBOutlet private weak var createDateLabel: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var newMessageImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nameLabel.text = ""
        self.lastMessageLabel.text = ""
        self.createDateLabel.text = ""
        self.newMessageImageView.image = UIImage()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func chatListCellFilling(roomDetails: RoomDetails) {
        let format = DateFormatter()
        format.dateFormat = Constant.CustomElements.dateFormat
        self.lastMessageLabel.text = roomDetails.lastMessageBody
        self.createDateLabel.text = format.string(from: roomDetails.lastMessageCreateDate)
        self.nameLabel.text = roomDetails.userName
        self.userImage.image = roomDetails.userImage

        if roomDetails.lastMessageRead == true {
            self.newMessageImageView.image = UIImage()
        } else {
            self.newMessageImageView.image = UIImage(systemName: Constant.SystemImagesNames.newMessageBubble)
        }
    }
}
