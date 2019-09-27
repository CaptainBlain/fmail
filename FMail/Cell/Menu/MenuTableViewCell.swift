//
//  MenuTableViewCell.swift
//  FMail
//
//  Created by Blain Ellis on 26/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    static var identifier = "MenuTableViewCellIdentifier"
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var titleString = ""
    var dotColor = UIColor.getAppBlueColor()
    var showArrowImage = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        topView.alpha = 0.0
        bottomView.alpha = 0.0
        
        dotView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

        menuTitleLabel.text = titleString
        dotView.backgroundColor = dotColor
       
        arrowImageView.isHidden = !showArrowImage
        

    }
    
    
}
