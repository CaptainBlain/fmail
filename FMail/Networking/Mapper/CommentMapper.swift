//
//  CommentsMapper.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import ObjectMapper

public class CommentMapper: Mappable {
    var _id: String?
    var owner: OwnerMapper?
    var to: String?
    var subject: String?
    var content: String?
    var comments: [String]?
    var createdDate: Date?
    
    public required init?(map: Map){
        
    }
    
    public func mapping(map: Map) {
        _id <- map["_id"]
        owner <- map["owner"]
        to <- map["to"]
        subject <- map["subject"]
        content <- map["content"]
        comments <- map["comments"]
        comments <- map["comments"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let dateString = map["createdDate"].currentValue as? String {
            let _date = dateFormatter.date(from: dateString)
            createdDate = _date
        }

    }
}
