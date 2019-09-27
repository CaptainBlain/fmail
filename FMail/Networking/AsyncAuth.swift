//
//  AsyncAuth.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import ObjectMapper

class AsyncAuth {
    
    static func registerUser(completion: @escaping (_ error: BMError?)->()) {
        
        let pwaosrsd = UUID().uuidString
        let parameters: Parameters = ["password" : pwaosrsd]
        
        print(parameters)
        
        Alamofire.request(Constant.apiUrl + "/users/register", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                
                print("response.result.value:", response.result.value ?? "NIL")
                
                if(response.response?.statusCode == 200) {
                    
                    if let user = Mapper<UserMapper>().map(JSONObject: response.result.value) {
                        UserDefaults.standard.set(user.username, forKey: UserDefaults.Key.nuuassmeeerr)
                        UserDefaults.standard.set(pwaosrsd, forKey: UserDefaults.Key.wpuoasrsedsr)
                        UserDefaults.standard.synchronize()
                    }
                    
                    completion(nil);
                }
                else {
                    
                    var message = ""
                    
                    if let errorMessageDict = response.result.value as? [String:String] {
                        
                        message = errorMessageDict["message"] ?? "Unknown Error"
                    }
                    
                    completion(BMError(0, message));
                }
                
                
                
            case .failure(let error):
                print(error)
                
                completion(BMError(response.response?.statusCode ?? 0, error.localizedDescription));
            }
        })
        
        
    }
    
    static func loginUser(completion: @escaping (_ error: BMError?, _ user: UserMapper?)->()) {
        

        guard let username = UserDefaults.standard.object(forKey: UserDefaults.Key.nuuassmeeerr) as? String else { return }
        guard let password = UserDefaults.standard.object(forKey: UserDefaults.Key.wpuoasrsedsr) as? String else { return }
        
        let parameters: Parameters = ["username": username, "password" :password]
        
        print("username:", username, " password", password)
        
        Alamofire.request(Constant.apiUrl + "/users/authenticate", method: .post, parameters: parameters).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success:
                
                print("loginUser:", response.result.value ?? "")
                
                if(response.response?.statusCode == 200) {
                    
                    let user = Mapper<UserMapper>().map(JSONObject: response.result.value)
                    
                    completion(nil, user!);
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
