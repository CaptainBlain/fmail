//
//  AppStoryboard.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard : String {
    case Main, Login, Timeline, Event, Trader
    
    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController<T: UIViewController>(viewControllerClass : T.Type) -> T {
        
        let storyBoardId = (viewControllerClass as UIViewController.Type).storyboardID
        
        return instance.instantiateViewController(withIdentifier:storyBoardId) as! T
    }
    
    func initialViewController() -> UIViewController? {
        
        return instance.instantiateInitialViewController()
    }
    
    
}
