//
//  Keychain.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import Foundation

class Keychain {
    
    static let SecClass = kSecClass as NSString
    static let SecClassGenericPassword = kSecClassGenericPassword as NSString
    static let SecAttrAccount = kSecAttrAccount as NSString
    static let SecAttrService = kSecAttrService as NSString
    static let SecValueData = kSecValueData as NSString
    static let SecMatchLimit = kSecMatchLimit as NSString
    static let SecReturnData = kSecReturnData as NSString
    
    
    private class func queryDictionary(_ identifier: String) -> NSMutableDictionary {
        let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! NSString
        
        let queryDictionary: NSMutableDictionary = [SecClass : SecClassGenericPassword]
        queryDictionary[SecAttrAccount] = identifier
        queryDictionary[SecAttrService] = bundleIdentifier
        
        return queryDictionary
    }
    
    
    class public func createValue(_ value: String, forIdentifier identifier: String) -> Bool {
        let query = queryDictionary(identifier)
        query[SecValueData] = value.data(using: String.Encoding.utf8)! as NSData
        
        let status: OSStatus = SecItemAdd(query, nil)
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return updateValue(value, forIdentifier: identifier)
        } else {
            return false
        }
    }
    
    
    class public func getValue(_ identifier: String) -> String {
        let query = queryDictionary(identifier)
        query[SecMatchLimit] = kSecMatchLimitOne
        query[SecReturnData] = kCFBooleanTrue
        
        var result: AnyObject?
        let status = withUnsafeMutablePointer(to: &result) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        
        if status == noErr {
            if let data = result as! Data? {
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }
        }
        
        return ""
    }
    
    
    class public func updateValue(_ value: String, forIdentifier identifier: String) -> Bool {
        let query = queryDictionary(identifier)
        let updateDictionary = [SecValueData:value.data(using: String.Encoding.utf8)!]
        
        let status: OSStatus = SecItemUpdate(query, updateDictionary as CFDictionary)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
    
    
    class public func deleteValue(_ identifier: String) -> Bool {
        let query = queryDictionary(identifier)
        
        let status: OSStatus = SecItemDelete(query)
        if status == errSecSuccess {
            return true
        } else {
            return false
        }
    }
}
