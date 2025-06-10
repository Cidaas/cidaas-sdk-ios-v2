//
//  URLHelper.swift
//  sdkiOS
//
//  Created by Ganesh on 25/05/2025.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation
import JWTDecode


public class TokenHelper: NSObject {
    
    // shared instance
    public static var shared : TokenHelper = TokenHelper()
    
    func getSubFromAccessToken(from token: String) -> String? {
        do {
            let jwt = try decode(jwt: token)
            return jwt.claim(name: "sub").string
        } catch {
            print("Failed to decode JWT: \(error)")
            return nil
        }
    }
}


    

