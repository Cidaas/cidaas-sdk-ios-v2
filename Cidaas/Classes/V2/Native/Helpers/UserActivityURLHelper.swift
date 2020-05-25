//
//  UserActivityURLHelper.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class UserActivityURLHelper {
    
    public static var shared : UserActivityURLHelper = UserActivityURLHelper()
    
    public var userActivityURL = "/useractivity-srv/latestactivity"
    
    public func getUserActivityURL() -> String {
        return userActivityURL
    }
}
