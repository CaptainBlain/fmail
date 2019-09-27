//
//  AsyncPosts.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

enum PostType: String {
    
    case latest = "latest"
    
}

class AsynPosts {
    
    static func getPosts(forUser user: User, forPage page: Int, andType type: PostType, completion: @escaping (_ error: BMError?, _ posts: [PostMapper]?)->()) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(user.token!)"]
        
        Alamofire.request(Constant.apiUrl + "/posts/getAll?type=\(type.rawValue)&page=\(page)", method: .get, headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                
                print("getPosts response.result.value:", response.result.value ?? "NIL")
                
                if(response.response?.statusCode == 200) {
                    
                    let posts = Mapper<PostMapper>().mapArray(JSONArray: response.value as! [[String : Any]])
                    
                    completion(nil, posts);
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
    
    static func sendPost(forUser user: User, subject: String, content: String, completion: @escaping (_ error: BMError?, _ post: Post?)->()) {
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(user.token!)"]
        
        let parameters: Parameters = ["owner" : user.identifier ?? "",
                                      "subject" : subject,
                                      "content" : content]
                
        Alamofire.request(Constant.apiUrl + "/posts/create", method: .post, parameters: parameters, headers: headers).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                
                print("response.result.value:", response.result.value ?? "NIL")
                
                if(response.response?.statusCode == 200) {
                    
                    if let postMapper = Mapper<PostMapper>().map(JSONObject: response.result.value) {
                        
                        let post = Post(postMapper)
                        
                         completion(nil, post);
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
