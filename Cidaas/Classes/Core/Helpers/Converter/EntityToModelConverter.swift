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
    
    // access token entity to model
    public func accessTokenEntityToAccessTokenModel(accessTokenEntity : AccessTokenEntity, callback: @escaping (AccessTokenModel)-> Void) {
        
        AccessTokenModel.shared.salt = randomString(length: 16)
        AccessTokenModel.shared.key = randomString(length: 16)
        AccessTokenModel.shared.expires_in = accessTokenEntity.expires_in
        AccessTokenModel.shared.id_token = accessTokenEntity.id_token
        AccessTokenModel.shared.refresh_token = accessTokenEntity.refresh_token
        AccessTokenModel.shared.sub = accessTokenEntity.sub
        AccessTokenModel.shared.access_token = try! accessTokenEntity.access_token.aesEncrypt(key: AccessTokenModel.shared.key, iv: AccessTokenModel.shared.salt)
        
        callback(AccessTokenModel.shared)
    }
    
    // access token model to entity
    public func accessTokenModelToAccessTokenEntity(accessTokenModel : AccessTokenModel = AccessTokenModel.shared, callback: @escaping (AccessTokenEntity)-> Void) {
        let accessTokenEntity = AccessTokenEntity()
        
        accessTokenEntity.expires_in = accessTokenModel.expires_in
        accessTokenEntity.id_token = accessTokenModel.id_token
        accessTokenEntity.refresh_token = accessTokenModel.refresh_token
        accessTokenEntity.sub = accessTokenModel.sub

        accessTokenEntity.access_token = try! accessTokenModel.access_token.aesDecrypt(key: accessTokenModel.key, iv: accessTokenModel.salt)
        
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
