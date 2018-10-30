//
//  Facebook.swift
//  Cidaas
//
//  Created by ganesh on 15/10/18.
//

import Foundation

public class Facebook {
    
    // shared instance
    public static var shared : Facebook = Facebook()
    public var delegate: UIViewController!
    
    public init() {
        
    }
    
    public func login(callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        let savedProp = DBHelper.shared.getPropertyFile()
        if (savedProp != nil) {
            FacebookController.shared.delegate = delegate
            FacebookController.shared.login(properties: savedProp!, callback: callback)
        }
            
        else {
            // log error
            let loggerMessage = "Read properties file failure : " + "Error Code -  10001, Error Message -  File not found, Status Code - 404"
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            let error = WebAuthError.shared.fileNotFoundException()
            
            // return failure callback
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
    }
}
