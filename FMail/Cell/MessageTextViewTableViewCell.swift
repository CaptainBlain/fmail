//
//  MessageTextViewTableViewCell.swift
//  FMail
//
//  Created by Blain Ellis on 24/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit

protocol MessageTextViewTableViewCellDelegate: AnyObject {
    func messageTextViewTableViewCellBeginEditing(forIndexPath indexPath: IndexPath);
    func messageTextViewTableViewCellDidUpdateText(text: String, forIndexPath indexPath: IndexPath)
}
class MessageTextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    public static let identifier = "MessageTextViewTableViewCellIdentifier"
    
    @IBOutlet weak var messageTextView: UITextView!
    
    var messagePlaceholder = ""
    var messageString = ""
    
    weak var delegate: MessageTextViewTableViewCellDelegate?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        messageTextView.delegate = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        messageTextView.text = messagePlaceholder
        messageTextView.textColor = UIColor.lightGray
        
        if !messageString.isEmpty {
            messageTextView.text = messageString;
            messageTextView.textColor = UIColor.darkTextColor()
        }
       
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.delegate?.messageTextViewTableViewCellBeginEditing(forIndexPath: indexPath)
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.darkTextColor()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            messageTextView.text = messageString;
            messageTextView.textColor = UIColor.darkTextColor()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.delegate?.messageTextViewTableViewCellDidUpdateText(text: newText, forIndexPath: indexPath)
        
        return true
    }
    
}


