//
//  Post.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import Foundation

class Post {
    
    var identifier: String?
    var ownerUsername: String
    var subject: String
    var content: String
    var comments: [String]?
    var votes: String?
    var createdDate: Date?
    var updatedDate: Date?
    var starred: Bool = false
    
    init(_ postMapper: PostMapper) {
        self.identifier = postMapper._id
        self.ownerUsername = postMapper.ownerUsername ?? ""
        self.subject = postMapper.subject ?? ""
        self.content = postMapper.content ?? ""
        
        /*var commentsArray = [Comment]()
        if let commentsMapper = postMapper.comments {
            for commentMapper in commentsMapper {
                commentsArray.append(Comment(commentMapper))
            }
        }*/
        self.comments = postMapper.comments;
        self.subject = postMapper.subject ?? "";
        self.createdDate = postMapper.createdDate
    }
}
/*
 owner: { type: Schema.Types.ObjectId, ref: 'User', required: true },
 subject: { type: String, required: false },
 content: { type: String, required: false },
 //category:  CategorySchema ,
 comments: [CommentSchema],
 votes: { type: Number },
 createdDate: { type: Date, default: Date.now },
 updatedDate: { type: Date, default: Date.now }
 */
