//
//  BaseAsync.swift
//  caliesta-business
//
//  Created by Blain Ellis on 16/08/2019.
//  Copyright © 2019 caliesta. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class BaseAsync {
    
    //Extension
    static func completeForEmptyResponse(response:DataResponse<Any>, completion: @escaping (_ error: BMError?)->()) {
        
        switch response.result {
        case .success:
            
            if(response.response?.statusCode == 200) {
                completion(nil);
            } else {
                //Check for Auth
                if (response.response?.statusCode == 401) {
                    //Insta logout
                    //(UIApplication.shared.delegate as! AppDelegate).logout()
                    return;
                }
                else {
                    var message = ""
                    if let errorMessageDict = response.result.value as? [String:String] {
                        message = errorMessageDict["message"] ?? "Unknown Error"
                    }
                    completion(BMError(0, message));
                }
            }
        case .failure(let error):
            print(error)
            
            completion(BMError(error._code, error.localizedDescription));
        }
    }
    
    static func handleSuccess(_ response:DataResponse<Any>, completion: @escaping (_ error: BMError?, _ respose:HTTPURLResponse?)->()) {
        
        if(response.response?.statusCode == 200) {
            
            completion(nil, response.response);
            
        }
        else {
            //Check for Auth
            if (response.response?.statusCode == 401) {
                //Insta logout
                //(UIApplication.shared.delegate as! AppDelegate).logout()
                return;
            }
            else {
                var message = ""
                if let errorMessageDict = response.result.value as? [String:String] {
                    message = errorMessageDict["message"] ?? "Unknown Error"
                }
                completion(BMError(0, message), nil);
            }
        }
        
    }
}
