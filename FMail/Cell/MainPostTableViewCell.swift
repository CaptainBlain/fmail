//
//  MainPostTableViewCell.swift
//  FMail
//
//  Created by Blain Ellis on 24/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit

protocol MainPostTableViewCellDelegate: AnyObject {
    func mainPostTableViewCellDidPressReply(forPost post: Post)
}
class MainPostTableViewCell: UITableViewCell {

    public static let identifier = "MainPostTableViewCellIdentifier"
    
    var post: Post?
    weak var delegate: MainPostTableViewCellDelegate?
    
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var titleLabelConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var postUsernameLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    @IBOutlet weak var contentLableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postCommentsCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        /*postTitleLabel.backgroundColor = UIColor.red
        postUsernameLabel.backgroundColor = UIColor.blue
        postContentLabel.backgroundColor = UIColor.yellow
        postCommentsCountLabel.backgroundColor = UIColor.green*/
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let post = post {
            
            let titleHeight: CGFloat = post.subject.getStringSize(for: UIFont.robotoBold(size: 17), andWidth: self.frame.size.width - 24).height
            titleLabelConstraintHeight.constant = titleHeight
            postTitleLabel.text = post.subject
            postTitleLabel.sizeToFit()
            
            var commentsCount = ""
            if let comments = post.comments {
                commentsCount = comments.count == 0 ? "" : comments.count > 99999 ? " ● 99999+ comments" : " ● \(comments.count) comments"
            }
            postUsernameLabel.text = post.ownerUsername + commentsCount

            let contentHeight: CGFloat = post.content.getStringSize(for: UIFont.robotoLight(size: 17), andWidth: self.frame.size.width - 24).height
            contentLableHeightConstraint.constant = contentHeight
            postContentLabel.text = post.content
            postContentLabel.sizeToFit()
           
            var dateParse = ""
            if let createdDate = post.createdDate {
                dateParse = createdDate.getDateStringForCreatedTime()
            }
            postCommentsCountLabel.text = dateParse
            
            replyButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            
        }
    }
    @IBAction func didPressReplyButton(_ sender: Any) {
         if let post = post {
            self.delegate?.mainPostTableViewCellDidPressReply(forPost: post)
        }
    }
    
}
