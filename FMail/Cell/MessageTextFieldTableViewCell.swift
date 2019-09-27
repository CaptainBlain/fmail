//
//  MessageTextFieldTableViewCell.swift
//  FMail
//
//  Created by Blain Ellis on 24/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit

protocol MessageTextFieldTableViewCellDelegate: AnyObject {
    func messageTextFieldTableViewCellBeginEditing(forIndexPath indexPath: IndexPath);
    func messageTextFieldTableViewDidUpdateText(text: String, forIndexPath indexPath: IndexPath)
}
class MessageTextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    public static let identifier = "MessageTextFieldTableViewCellIdentifier"
    
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    
    var messageTitle = ""
    var messagePlaceholder = ""
    var messageString = ""
    var indexPath: IndexPath!
    var captialType = UITextAutocapitalizationType.none

    weak var delegate: MessageTextFieldTableViewCellDelegate?
    private var messageText: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        messageTextField.delegate = self;
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        messageTextField.autocapitalizationType = captialType
        messageTitleLabel.text = messageTitle
        messageTextField.placeholder = messagePlaceholder
        if !messageString.isEmpty {
            messageTextField.text = messageString
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.messageTextFieldTableViewCellBeginEditing(forIndexPath: indexPath)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            messageText = updatedText;
            self.delegate?.messageTextFieldTableViewDidUpdateText(text: updatedText, forIndexPath: indexPath)
        }
        return true
    }
    
}
