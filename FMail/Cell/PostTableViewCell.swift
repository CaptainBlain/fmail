//
//  PostTableViewCell.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    public static var identifier = "PostTableViewCellIdentifier"
    
    //@IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postUsernameLabel: UILabel!
    @IBOutlet weak var postContentLabel: UILabel!
    
    @IBOutlet weak var postButton: UIButton!
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        //postImageView.layer.cornerRadius = 14
        //postImageView.layer.borderColor = UIColor.darkGreyColor().cgColor
        //postImageView.layer.borderWidth = 1.0
        //postImageView.backgroundColor = UIColor.getLightPurpleColor()
        postButton.backgroundColor = UIColor.clear
        postButton.tintColor = UIColor.darkGray
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let post = post {
            
            postTitleLabel.text = post.subject
            
            var commentsCount = ""
            if let comments = post.comments {
                commentsCount = comments.count == 0 ? "" : comments.count > 99999 ? " ● 99999+ comments" : " ● \(comments.count) comments"
            }
            
            postUsernameLabel.text = post.ownerUsername + commentsCount
            
            postContentLabel.text = post.content
            
            postButton.setImage(post.starred ? UIImage(named: "star_full") : UIImage(named: "star_empty"), for: UIControl.State.normal)
            postButton.tintColor = post.starred ? UIColor.yellowBarColor() : UIColor.darkGray
            
        }
        
    }
    
    @IBAction func didPressPostButton(_ sender: Any) {
        if let post = post {
            post.starred = !post.starred
            postButton.setImage(post.starred ? UIImage(named: "star_full") : UIImage(named: "star_empty"), for: UIControl.State.normal)
            postButton.tintColor = post.starred ? UIColor.yellowBarColor() : UIColor.darkGray
        }
       
    }
}
