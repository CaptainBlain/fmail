//
//  UIViewController+Extension.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import UIKit

extension UIViewController {
    class var storyboardID : String {
        return "\(self)"
    }
    
    static func instantiate(fromAppStoryboard appStoryboard: AppStoryboard) -> Self {
        
        return appStoryboard.viewController(viewControllerClass: self)
    }
}

