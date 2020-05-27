//
//  UserActivityViewController.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class UserActivityViewController {
    
    public static var shared: UserActivityViewController = UserActivityViewController()
    var sharedInteractor: UserActivityInteractor
    
    public init() {
        sharedInteractor = UserActivityInteractor.shared
    }
    
    // Get User Activity
    public func getUserActivity(accessToken : String, incomingData: UserActivityEntity, callback: @escaping(Result<UserActivityResponseEntity>) -> Void) {
        sharedInteractor.getUserActivity(accessToken: accessToken, incomingData: incomingData, callback: callback)
    }
}
