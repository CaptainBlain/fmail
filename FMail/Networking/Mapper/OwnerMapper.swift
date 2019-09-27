//
//  OwnerMapper.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import ObjectMapper

public class OwnerMapper: Mappable {
    var username: String?
    
    public required init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        username <- map["username"]
    }
}
