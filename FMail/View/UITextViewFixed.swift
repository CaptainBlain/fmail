//
//  UITextViewFixed.swift
//  FMail
//
//  Created by Blain Ellis on 24/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit

class UITextViewFixed: UITextView {

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }

}
