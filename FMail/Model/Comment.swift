//
//  Comment.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import Foundation

class Comment {
    
    var identifier: String?
    var to: String?
    var ownerUsername: String
    var subject: String
    var content: String
    var comments: [String]?
    var votes: String?
    var createdDate: Date?
    var updatedDate: Date?
    
    init(_ commentMapper: CommentMapper) {
        
        self.identifier = commentMapper._id
        self.ownerUsername = commentMapper.owner?.username ?? ""
        self.to = commentMapper.to ?? ""
        self.subject = commentMapper.subject ?? ""
        self.content = commentMapper.content ?? ""
        /*var commentsArray = [Comment]()
        if let commentsMapper = commentMapper.comments {
            for commentMapper in commentsMapper {
                commentsArray.append(Comment(commentMapper))
            }
        }*/
        self.comments = commentMapper.comments;
        self.createdDate = commentMapper.createdDate;
    }
}
