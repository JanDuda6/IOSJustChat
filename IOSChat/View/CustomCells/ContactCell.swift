//
//  ContactCell.swift
//  IOSChat
//
//  Created by Kurs on 05/02/2021.
//

import UIKit

class ContactCell: UITableViewCell {
    @IBOutlet private weak var userImage: UIImageView!
    @IBOutlet private weak var userName: UILabel!
    @IBOutlet private weak var userEmail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userName.text = ""
        self.userEmail.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func contactCellFilling(user: User) {
        self.userImage.image = user.photo
        self.userName.text = user.name
        self.userEmail.text = user.email
    }
}
