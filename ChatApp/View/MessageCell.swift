//
//  MessageCell.swift
//  ChatApp
//
//  Created by Gray Zhen on 11/10/17.
//  Copyright © 2017 GrayStudio. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    //IBOutlets
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageBodyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBodyLbl.preferredMaxLayoutWidth = 210
    
    }

    func configureCell(message: Message) {
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        messageBodyLbl.text = message.message
        userNameLbl.text = message.userName
    }
    
}
