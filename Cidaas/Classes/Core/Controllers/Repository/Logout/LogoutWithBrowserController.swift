//
//  File.swift
//
//
//  Created by Widas Ganesh RH on 18/03/25.
//

import Foundation

import UIKit
import SafariServices

public class LogoutWithBrowserController: NSObject, SFSafariViewControllerDelegate {
    // shared instance
    public static var shared : LogoutWithBrowserController = LogoutWithBrowserController()
    private var safariVC: SFSafariViewController?
    
    // logout With browser
    public func logoutWithBrowser(delegate: UIViewController, sub: String, postLogoutRedirectURL: String,properties: Dictionary<String, String>, callback: @escaping(Result<Bool>) -> Void) {
        // null check
        if properties["DomainURL"] == "" || properties["DomainURL"] == nil  {
            let error = WebAuthError.shared.propertyMissingException()
            // log error
            let loggerMessage = "Read properties failure : " + "Error Code - " + String(describing: error.errorCode) + ", Error Message - " + error.errorMessage + ", Status Code - " + String(describing: error.statusCode)
            logw(loggerMessage, cname: "cidaas-sdk-error-log")
            
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        // check if sub is empty
        if (sub == "") {
            let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "sub cannot be empty", statusCode: 417)
            DispatchQueue.main.async {
                callback(Result.failure(error: error))
            }
            return
        }
        
        
        AccessTokenController.shared.getAccessToken(sub: sub) {
            switch $0 {
            case .success(result: let tokenResp):
                var accessToken = tokenResp.data.access_token
                
                // check if sub is empty
                if (accessToken.isEmpty) {
                    let error = WebAuthError.shared.serviceFailureException(errorCode: 417, errorMessage: "access_token cannot be empty", statusCode: 417)
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
                
                var logoutUrl = self.generateLogoutURL(accessToken: tokenResp.data.access_token,  postLogoutRedirectURL: postLogoutRedirectURL,properties: properties)
                
                
                guard let logoutURL = URL(string: logoutUrl) else {
                    let error = WebAuthError.shared.serviceFailureException(errorCode: 400, errorMessage: "Invalid Logout URL: \(logoutUrl)", statusCode: 400)
                    DispatchQueue.main.async {
                        callback(Result.failure(error: error))
                    }
                    return
                }
                
                
                var isLogoutSuccess = self.logoutWithBrowser(from: delegate, logoutURL: logoutURL)
                callback(Result.success(result: isLogoutSuccess))
                
            case .failure(error: let error):
                // return callback
                DispatchQueue.main.async {
                    callback(Result.failure(error: error))
                }
                return
            }
        }
        
    }
    
    public func generateLogoutURL(accessToken: String,  postLogoutRedirectURL: String,properties: Dictionary<String, String>) -> String {
        var components = URLComponents()
        var domainURL = properties["DomainURL"] ?? ""
        var logoutURL = ""
        
        if (!accessToken.isEmpty) {
            if (!postLogoutRedirectURL.isEmpty) {
                logoutURL = domainURL + LoginURLHelper.shared.getLogout(accessToken: accessToken) + "&post_logout_redirect_uri=" + postLogoutRedirectURL
            } else {
                logoutURL = domainURL + LoginURLHelper.shared.getLogout(accessToken: accessToken)
            }
        }
        
        return logoutURL
    }
    
    public func logoutWithBrowser(from viewController: UIViewController, logoutURL: URL) -> Bool {
        
        let safariVC = SFSafariViewController(url: logoutURL)
        safariVC.delegate = self
        self.safariVC = safariVC
        
        viewController.present(safariVC, animated: true, completion: nil)
        return true
    }
    
}
