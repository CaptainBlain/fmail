//
//  UserMapper.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import ObjectMapper

public class UserMapper: Mappable {
    var _id: String?
    var token: String?
    var username: String?
    
    public required init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        _id <- map["_id"]
        token <- map["token"]
        username <- map["username"]
    }
}
