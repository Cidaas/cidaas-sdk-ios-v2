//
//  CidaasGoogle.swift
//  Cidaas_Example
//
//  Created by ganesh on 21/01/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import GoogleSignIn
import Cidaas

public class CidaasGoogle : UIViewController, GIDSignInUIDelegate, CidaasGoogleDelegate {
    
    public static var shared : CidaasGoogle = CidaasGoogle()
    var googleCallback: ((Result<LoginResponseEntity>) -> ())!
    var viewType: String = "login"
    var DELEGATE: UIViewController!
    
    public var delegate: UIViewController {
        get {
            return self.DELEGATE
        }
        set(delegate) {
            CidaasView.googleDelegate = self
            self.DELEGATE = delegate
        }
    }
    
    var googleViewController: UIViewController!
    
    public func login(viewType: String, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        self.viewType = viewType
        self.googleCallback = callback
    }
    
    public func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(viewController, animated: true, completion: nil)
            googleViewController = viewController
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        googleViewController.dismiss(animated: true, completion: nil)
    }
    
    public func didSignIn(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if user != nil {
            Cidaas.shared.getAccessToken(socialToken: user.authentication.accessToken ?? "", provider: "google", viewType: self.viewType, callback: googleCallback)
        }
        else {
           googleCallback(Result.failure(error: WebAuthError.shared.noUserFoundException()))
        }
    }
    
    func configure(_ appDelegate : AppDelegate) {
        let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
        if path != nil {
            
            let dict = NSDictionary(contentsOfFile: path!)
            
            if let clientID = dict?.object(forKey: "CLIENT_ID") {
                GIDSignIn.sharedInstance().clientID = clientID as? String ?? ""
                GIDSignIn.sharedInstance().delegate = appDelegate
            }
        }
    }
}
