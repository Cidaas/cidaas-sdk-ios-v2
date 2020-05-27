//
//  DeduplicationURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class DeduplicationURLHelper {
    
    public static var shared : DeduplicationURLHelper = DeduplicationURLHelper()
    
    public var deduplicationDetails = "/users-srv/deduplication/info"
    public var registerDeduplicationURL = "/users-srv/deduplication/register"
    public var loginDeduplicationURL = "/login-srv/login/sdk"
    
    public func getDeduplicationDetailsURL(track_id: String) -> String {
        return deduplicationDetails + "/" + track_id
    }
    
    public func getRegisterDeduplicationURL(track_id: String) -> String {
        return registerDeduplicationURL + "/" + track_id
    }
    
    public func getLoginDeduplicationURL() -> String {
        return loginDeduplicationURL
    }
}
