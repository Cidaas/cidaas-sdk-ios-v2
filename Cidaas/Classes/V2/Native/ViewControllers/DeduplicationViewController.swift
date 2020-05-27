//
//  DeduplicationViewController.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class DeduplicationViewController {
    
    public static var shared: DeduplicationViewController = DeduplicationViewController()
    var sharedInteractor: DeduplicationInteractor
    
    public init() {
        sharedInteractor = DeduplicationInteractor.shared
    }
    
    // Get Deduplication details
    public func getDeduplicationDetails(track_id: String, callback: @escaping(Result<DeduplicationDetailsResponseEntity>) -> Void) {
        sharedInteractor.getDeduplicationDetails(track_id: track_id, callback: callback)
    }
    
    // Register Deduplication
    public func registerDeduplication(track_id: String, callback: @escaping(Result<RegistrationResponseEntity>) -> Void) {
        sharedInteractor.registerDeduplication(track_id: track_id, callback: callback)
    }
    
    // Deduplication Login
    public func deduplicationLogin(incomingData : LoginEntity, callback: @escaping(Result<LoginResponseEntity>) -> Void) {
        sharedInteractor.deduplicationLogin(incomingData: incomingData, callback: callback)
    }
}
