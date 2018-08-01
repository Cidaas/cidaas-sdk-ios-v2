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
        AccessTokenModel.shared.expiresIn = accessTokenEntity.expires_in
        AccessTokenModel.shared.idToken = accessTokenEntity.id_token
        AccessTokenModel.shared.refreshToken = accessTokenEntity.refresh_token
        AccessTokenModel.shared.userId = accessTokenEntity.sub
        AccessTokenModel.shared.accessToken = try! accessTokenEntity.access_token.aesEncrypt(key: AccessTokenModel.shared.salt, iv: AccessTokenModel.shared.salt)
        AccessTokenModel.shared.isEncrypted = true
        
        callback(AccessTokenModel.shared)
    }
    
    // access token model to entity
    public func accessTokenModelToAccessTokenEntity(accessTokenModel : AccessTokenModel = AccessTokenModel.shared, callback: @escaping (AccessTokenEntity)-> Void) {
        let accessTokenEntity = AccessTokenEntity()
        
        
        accessTokenEntity.expires_in = accessTokenModel.expiresIn
        accessTokenEntity.id_token = accessTokenModel.idToken
        accessTokenEntity.refresh_token = accessTokenModel.refreshToken
        accessTokenEntity.sub = accessTokenModel.userId
        
        if accessTokenModel.isEncrypted == true {
            accessTokenEntity.access_token = try! accessTokenModel.accessToken.aesDecrypt(key: accessTokenModel.salt, iv: accessTokenModel.salt)
            callback(accessTokenEntity)
        }
        else {
            accessTokenEntity.access_token = accessTokenModel.accessToken
            callback(accessTokenEntity)
        }
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
