//
//  CommentTableViewCell.swift
//  FMail
//
//  Created by Blain Ellis on 24/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    public static let identifier = "CommentTableViewCellIdentifier"
    
    var comment: Comment!
    
    @IBOutlet weak var commentFromLabel: UILabel!
    @IBOutlet weak var commentFromLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var commentSentLabel: UILabel!
    @IBOutlet weak var commentSentLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var commentToLabel: UILabel!
    @IBOutlet weak var commentToLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var commentSubjectLabel: UILabel!
    @IBOutlet weak var commentSubjectLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var commentContentLabel: UILabel!
    @IBOutlet weak var commentContentLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var replyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        commentFromLabel.text = ""
        commentSentLabel.text = ""
        commentToLabel.text = ""
        commentSubjectLabel.text = ""
        commentContentLabel.text = ""
        
        /*commentFromLabel.backgroundColor = UIColor.red
        commentSentLabel.backgroundColor = UIColor.green
        commentToLabel.backgroundColor = UIColor.blue
        commentSubjectLabel.backgroundColor = UIColor.yellow
        commentContentLabel.backgroundColor = UIColor.orange*/
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Reset everything
        commentFromLabel.text = ""
        commentSentLabel.text = ""
        commentToLabel.text = ""
        commentSubjectLabel.text = ""
        commentContentLabel.text = ""
        
        commentFromLabel.attributedText = nil
        commentSentLabel.attributedText = nil
        commentToLabel.attributedText = nil
        commentSubjectLabel.attributedText = nil
        commentContentLabel.attributedText = nil
        
        commentFromLabelHeightConstraint.constant = 0
        commentSentLabelHeightConstraint.constant = 0
        commentToLabelHeightConstraint.constant = 0
        commentSubjectLabelHeightConstraint.constant = 0
        commentContentLabelHeightConstraint.constant = 0
        
        let darkFont = UIFont.robotoBold(size: 17)
        let lightFont = UIFont.roboto(size: 17)
        
        if let comment = comment {
                        
            let fromHeight = "From: \(comment.ownerUsername)".getStringSize(for: darkFont, andWidth: self.frame.size.width - 24).height
            commentFromLabelHeightConstraint.constant = fromHeight
            
            let fromString = NSMutableAttributedString(string: "From: ", attributes: NSAttributedString.getFontWithColour(font: darkFont, color: UIColor.darkTextColor()))
            let ownerUsernameString = NSMutableAttributedString(string: comment.ownerUsername, attributes: NSAttributedString.getFontWithColour(font: lightFont, color: UIColor.darkTextColor()))
            fromString.append(ownerUsernameString)
            commentFromLabel.attributedText = fromString
            commentFromLabel.sizeToFit()
            
            if let createdDate = comment.createdDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .full
                dateFormatter.timeStyle = .medium
                let dateString = dateFormatter.string(from: createdDate as Date)
                
                let sentHeight = "Sent: \(dateString)".getStringSize(for: darkFont, andWidth: self.frame.size.width - 24).height
                commentSentLabelHeightConstraint.constant = sentHeight
                
                let sentString = NSMutableAttributedString(string: "Sent: ", attributes: NSAttributedString.getFontWithColour(font: darkFont, color: UIColor.darkTextColor()))
                let commentDateString = NSMutableAttributedString(string: dateString, attributes: NSAttributedString.getFontWithColour(font: lightFont, color: UIColor.darkTextColor()))
                sentString.append(commentDateString)
                commentSentLabel.attributedText = sentString
                commentSentLabel.sizeToFit()
            }
            
            if let to = comment.to {
                
                let toHeight = "To: \(to)".getStringSize(for: darkFont, andWidth: self.frame.size.width - 24).height
                commentToLabelHeightConstraint.constant = toHeight
                
                let toString = NSMutableAttributedString(string: "To: ", attributes: NSAttributedString.getFontWithColour(font: darkFont, color: UIColor.darkTextColor()))
                let commentToString = NSMutableAttributedString(string: to, attributes: NSAttributedString.getFontWithColour(font: lightFont, color: UIColor.darkTextColor()))
                toString.append(commentToString)
                commentToLabel.attributedText = toString
                commentToLabel.sizeToFit()
            }
            
            let subjectHeight = "Subject: \(comment.subject)".getStringSize(for: darkFont, andWidth: self.frame.size.width - 24).height
            commentSubjectLabelHeightConstraint.constant = subjectHeight
            
            let subjectString = NSMutableAttributedString(string: "Subject: ", attributes: NSAttributedString.getFontWithColour(font: darkFont, color: UIColor.darkTextColor()))
            let commentSubjectString = NSMutableAttributedString(string: comment.subject, attributes: NSAttributedString.getFontWithColour(font: lightFont, color: UIColor.darkTextColor()))
            subjectString.append(commentSubjectString)
            commentSubjectLabel.attributedText = subjectString
            commentSubjectLabel.sizeToFit()
            
            let contentHeight: CGFloat = comment.content.getStringSize(for: UIFont.robotoLight(size: 17), andWidth: self.frame.size.width - 36).height
            commentContentLabelHeightConstraint.constant = contentHeight
            
            commentContentLabel.text = comment.content
            commentContentLabel.sizeToFit()
            
            replyButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            
        }
    }
    
}
