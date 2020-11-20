//
//  LogoutViewController.swift
//  Alamofire
//
//  Created by Kundan Kishore on 19/11/20.
//

import Foundation

public class LogoutViewController{
    public static var shared: LogoutViewController = LogoutViewController()
    
    var sharedInteractor: LoginInteractor
       
       public init() {
           sharedInteractor = LoginInteractor.shared
       }
       
       // logout service
       public func logoutService() -> Void {
        sharedInteractor.logoutInteractor()
       }
    
}
