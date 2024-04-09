//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Admin on 3.06.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

//MARK: - MessageCellProtocol
protocol MessageCellProtocol {
    /// Set up the components of the message cell.
    /// - Parameters:
    ///   - messageLabelText: The text to be displayed in the message label.
    ///   - messageLabelTextColor: The color of the text in the message label.
    ///   - messageBubbleBgColor: The background color of the message bubble.
    ///   - avatarImage: A boolean value indicating whether the avatar image should be displayed.
    ///   - rightAvatarImage: A boolean value indicating whether the right avatar image should be displayed.
    func setUpCellComponents(messageLabelText: String, messageLabelTextColor: UIColor, messageBubbleBgColor: UIColor, avatarImage: Bool, rightAvatarImage: Bool)
}

class MessageCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var messageBubble: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var rightAvatarImageView: UIImageView!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 5
    }
    
}

//MARK: - MessageCellProtocol
extension MessageCell: MessageCellProtocol {
    
    func setUpCellComponents(messageLabelText: String, messageLabelTextColor: UIColor, messageBubbleBgColor: UIColor, avatarImage: Bool, rightAvatarImage: Bool) {
        messageLabel.text = messageLabelText
        messageLabel.textColor = messageLabelTextColor
        messageBubble.backgroundColor = messageBubbleBgColor
        avatarImageView.isHidden = avatarImage
        rightAvatarImageView.isHidden = rightAvatarImage
    }
    
}
