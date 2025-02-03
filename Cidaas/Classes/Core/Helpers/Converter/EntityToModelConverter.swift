//
//  EntityToModelConverter.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class EntityToModelConverter {
    
    // shared instance
    public static var shared : EntityToModelConverter = EntityToModelConverter()
    public var userDefaults = UserDefaults.standard
    
    
    // access token entity to model
    public func accessTokenEntityToAccessTokenModel(accessTokenEntity : AccessTokenEntity, callback: @escaping (AccessTokenModel)-> Void) {
        let salt = randomString(length: 16)
        let key = randomString(length: 16)
        let encData = (salt + "," + key).data(using: .utf8)!
        
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "salt,key",
        ]
        
        // deleted existing salt,key
        
        SecItemDelete(deleteQuery as CFDictionary)
        
        // Set attributes
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "salt,key",
            kSecValueData as String: encData,
        ]
        
        SecItemAdd(attributes as CFDictionary, nil)
        AccessTokenModel.shared.expires_in = accessTokenEntity.expires_in
        AccessTokenModel.shared.id_token = accessTokenEntity.id_token
        do {
            AccessTokenModel.shared.refresh_token = try accessTokenEntity.refresh_token.aesEncrypt(key: key, iv: salt)
        } catch {
            // to handle crashes
            AccessTokenModel.shared.refresh_token = accessTokenEntity.refresh_token
        }
        
        AccessTokenModel.shared.sub = accessTokenEntity.sub
        
        do {
            AccessTokenModel.shared.access_token = try accessTokenEntity.access_token.aesEncrypt(key: key, iv: salt)
        } catch {
            // to handle crashes
            AccessTokenModel.shared.access_token = accessTokenEntity.access_token
        }
        callback(AccessTokenModel.shared)
    }
    
    // access token model to entity
    public func accessTokenModelToAccessTokenEntity(accessTokenModel : AccessTokenModel = AccessTokenModel.shared, callback: @escaping (AccessTokenEntity)-> Void) {
        let accessTokenEntity = AccessTokenEntity()
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "salt,key",
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        
        var item: CFTypeRef?
        var salt: String = ""
        var key: String = ""
        // Check if user exists in the keychain
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            // Extract result
            if let existingItem = item as? [String: Any], let saltKey = existingItem[kSecValueData as String] as? Data,
               let saltKeyDecoded = String(data: saltKey, encoding: .utf8) {
                salt = saltKeyDecoded.components(separatedBy: ",")[0]
                key = saltKeyDecoded.components(separatedBy: ",")[1]
                
            }
            
        }
        
        accessTokenEntity.expires_in = accessTokenModel.expires_in
        accessTokenEntity.id_token = accessTokenModel.id_token
        do {
            accessTokenEntity.refresh_token = try accessTokenModel.refresh_token.aesDecrypt(key: key, iv: salt)
        } catch {
            // to handle crashes
            accessTokenEntity.refresh_token =  accessTokenModel.refresh_token
        }
        
        accessTokenEntity.sub = accessTokenModel.sub
        
        do {
            accessTokenEntity.access_token = try accessTokenModel.access_token.aesDecrypt(key: key, iv: salt)
        } catch {
            // to handle crashes
            accessTokenEntity.access_token = accessTokenModel.access_token
        }
        
        
        callback(accessTokenEntity)
    }
        
        public func randomString(length: Int) -> String {
            
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let len = UInt32(letters.length)
            
            var randomString = ""
            
            for _ in 0 ..< length {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            
            return randomString
        }
    }

