//
//  Data+BASE16.swift
//  FMail
//
//  Created by Blain Ellis on 19/09/2019.
//  Copyright © 2019 ellisappdevelopment. All rights reserved.
//

import Foundation

extension Data {
    
    
    public init(base16EncodedString encoded: String) {
        var data = Data()
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: encoded, options: [], range: NSMakeRange(0, encoded.count)) { match, flags, stop in
            let byteString = (encoded as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        self = data
    }
    
    
    public func base16EncodedString() -> String {
        var result = ""
        
        var bytesIterator = self.makeIterator()
        while let value = bytesIterator.next() {
            result += String(format: "%02x", value)
        }
        
        return result
    }
}
