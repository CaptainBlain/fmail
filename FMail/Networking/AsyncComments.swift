//
//  AsyncComments.swift
//  FMail
//
//  Created by Blain Ellis on 25/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper


class AsynComments {
    
    static func getComments(forUser user: User, forPost post: Post, completion: @escaping (_ error: BMError?, _ comments: [Comment]?)->()) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(user.token!)"]
        
        guard let postId = post.identifier else { return completion(BMError(0, "Post not found"), nil) }
        
        Alamofire.request(Constant.apiUrl + "/comments/getForPost/\(postId)", method: .get, headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                
                //print("getComments response.result.value:", response.result.value ?? "NIL")
                
                if(response.response?.statusCode == 200) {
                    
                    let commentsMapperArray = Mapper<CommentMapper>().mapArray(JSONArray: response.value as! [[String : Any]])
                    
                    var comments = [Comment]()
                  
                    for commentMapper in commentsMapperArray {
                        comments.append(Comment(commentMapper))
                    }
                    
                    completion(nil, comments)
                    
                }
                else {
                    
                    var message = ""
                    
                    if let errorMessageDict = response.result.value as? [String:String] {
                        
                        message = errorMessageDict["message"] ?? "Unknown Error"
                    }
                    
                    completion(BMError(0, message), nil);
                }

            case .failure(let error):
                print(error)
                
                completion(BMError(response.response?.statusCode ?? 0, error.localizedDescription), nil);
            }
        })
    }
    
    static func sendComment(forUser user: User, post: Post, subject: String, content: String, completion: @escaping (_ error: BMError?, _ comment: Comment?)->()) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(user.token!)"]
        
        guard let userId = user.identifier else { return completion(BMError(0, "User not found"), nil) }
        guard let postId = post.identifier else { return completion(BMError(0, "Post not found"), nil) }
        
        let parameters: Parameters = ["owner" : userId,
                                      "post" : postId,
                                      "subject" : subject,
                                      "content" : content]
                
        Alamofire.request(Constant.apiUrl + "/comments/create", method: .post, parameters: parameters, headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                
                //print("response.result.value:", response.result.value ?? "NIL")
                
                if(response.response?.statusCode == 200) {
                    
                    if let commentMapper = Mapper<CommentMapper>().map(JSONObject: response.result.value) {
                        
                        let comment = Comment(commentMapper)
                        
                         completion(nil, comment);
                    }
                    else {
                          completion(nil, nil);
                    }
                }
                else {
                    
                    var message = ""
                    
                    if let errorMessageDict = response.result.value as? [String:String] {
                        
                        message = errorMessageDict["message"] ?? "Unknown Error"
                    }
                    
                    completion(BMError(0, message), nil);
                }
                
                
                
            case .failure(let error):
                print(error)
                
                completion(BMError(response.response?.statusCode ?? 0, error.localizedDescription), nil);
            }
        })
    }
    
    static func sendComment(forUser user: User, comment: Comment, subject: String, content: String, completion: @escaping (_ error: BMError?, _ comment: Comment?)->()) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(user.token!)"]
        
        let parameters: Parameters = ["owner" : user.identifier ?? "",
                                      "comment": comment.identifier ?? "",
                                      "subject" : subject,
                                      "content" : content]
                
        Alamofire.request(Constant.apiUrl + "/posts/create", method: .post, parameters: parameters, headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                
                print("response.result.value:", response.result.value ?? "NIL")
                
                if(response.response?.statusCode == 200) {
                    
                    if let commentMapper = Mapper<CommentMapper>().map(JSONObject: response.result.value) {
                        
                        let comment = Comment(commentMapper)
                        
                         completion(nil, comment);
                    }
                    else {
                          completion(nil, nil);
                    }
                }
                else {
                    
                    var message = ""
                    
                    if let errorMessageDict = response.result.value as? [String:String] {
                        
                        message = errorMessageDict["message"] ?? "Unknown Error"
                    }
                    
                    completion(BMError(0, message), nil);
                }
                
                
                
            case .failure(let error):
                print(error)
                
                completion(BMError(response.response?.statusCode ?? 0, error.localizedDescription), nil);
            }
        })
    }
}
