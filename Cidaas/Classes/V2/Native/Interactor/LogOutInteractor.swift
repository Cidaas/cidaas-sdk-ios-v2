//
//  LogOutInteractor.swift
//  Alamofire
//
//  Created by Kundan Kishore on 19/11/20.
//

import Foundation

public class LogOutInteractor{
     public static var shared: LogOutInteractor = LogOutInteractor()
     var sharedService: LogoutServiceWorker
     var sharedPresenter: LogoutPresenter
    
    public init() {
           sharedService = LogoutServiceWorker.shared
           sharedPresenter = LogoutPresenter.shared
       }
    
    public func logoutInteractor() -> Void {
        sharedService.logoutServiceWorker()
        
    }
    
    
       
}
