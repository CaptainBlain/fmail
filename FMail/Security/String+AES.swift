//
//  String+AES.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import Foundation
import CommonCrypto


extension String {
    
    var encrypted: String {
        get {
            let aes = AES(key: "c8a836a1fa9d40c0ae3decd3873b38ff", iv: "9e3decf3b02c493b")!
            let encrypted = aes.encrypt(string: self)!
            let base16 = encrypted.base16EncodedString().data(using: .utf8)!
            let base64 = base16.base64EncodedString()
            return base64
        }
    }
    
    
    var decrypted: String {
        get {
            let aes = AES(key: "c8a836a1fa9d40c0ae3decd3873b38ff", iv: "9e3decf3b02c493b")!
            let base64 = Data(base64Encoded: self)!
            let base16 = String(data: base64, encoding: .utf8)!
            let encrypted = Data(base16EncodedString: base16)
            let decrypted = aes.decrypt(data: encrypted)!
            return decrypted
        }
    }
}


struct AES {
    
    private let key: Data
    private let iv: Data
    
    
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }
        
        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }
        
        
        self.key = keyData
        self.iv  = ivData
    }
    
    
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }
    
    
    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }
    
    
    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }
        
        let cryptLength = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128).count
        var cryptData   = Data(count: cryptLength)
        
        let keyLength = [UInt8](repeating: 0, count: kCCBlockSizeAES128).count
        let options   = CCOptions(kCCOptionPKCS7Padding)
        
        var bytesLength = Int(0)
        
        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                        CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes, keyLength, ivBytes, dataBytes, data.count, cryptBytes, cryptLength, &bytesLength)
                    }
                }
            }
        }
        
        guard status == kCCSuccess else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }
        
        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}
