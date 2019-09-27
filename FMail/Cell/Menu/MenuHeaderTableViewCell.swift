//
//  MenuHeaderTableViewCell.swift
//  FMail
//
//  Created by Blain Ellis on 26/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit

class MenuHeaderTableViewCell: UITableViewCell {

    static var identifier = "MenuHeaderTableViewCellIdentifier"
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
