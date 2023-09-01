//
//  StringExtensions.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import CryptoSwift

public extension String {
    
    // Encryption
    func aesEncrypt(key: String, iv: String) throws -> String {
        let data = self.data(using: .utf8)!
        guard let keyData = key.data(using: .utf8) else {
                   return "Invalid key"
               }
        guard let ivData = iv.data(using: .utf8) else {
                   return "Invalid iv"
               }

        let aes = try AES(key: keyData.bytes, blockMode: GCM(iv: ivData.bytes), padding: .noPadding)
        let encrypted = try aes.encrypt(data.bytes)
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
    
    // Decryption
    func aesDecrypt(key: String, iv: String) throws -> String {
        let data = Data(base64Encoded: self)!
        guard let keyData = key.data(using: .utf8) else {
                   return "Invalid key"
               }
        guard let ivData = iv.data(using: .utf8) else {
                   return "Invalid iv"
               }
        let aes = try AES(key: keyData.bytes, blockMode: GCM(iv: ivData.bytes), padding: .noPadding)

        let decrypted = try aes.decrypt([UInt8](data))
        let decryptedData = Data(decrypted)

                guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
                    return "Could not decrypt"
                }

                return decryptedString
        
    }
    
    // remove white space
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
