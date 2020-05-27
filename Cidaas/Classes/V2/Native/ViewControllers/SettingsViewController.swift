//
//  SettingsViewController.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class SettingsViewController {
    
    public static var shared: SettingsViewController = SettingsViewController()
    var sharedInteractor: SettingsInteractor
    
    public init() {
        sharedInteractor = SettingsInteractor.shared
    }
    
    // Get Endpoints
    public func getEndpoints(callback: @escaping(Result<EndpointsResponseEntity>) -> Void) {
        sharedInteractor.getEndpoints(callback: callback)
    }
}
