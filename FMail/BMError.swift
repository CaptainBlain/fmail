//
//  BMError.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import Foundation

class BMError {
    
    var errorId: Int
    var errorMessage: String
    
    init(_ errorId: Int,_ errorMessage: String) {
        self.errorId = errorId;
        self.errorMessage = errorMessage;
    }
}
