//
//  ClientViewController.swift
//  Cidaas
//
//  Created by Ganesh on 17/05/20.
//

import Foundation

public class ClientViewController {
    
    public static var shared: ClientViewController = ClientViewController()
    var sharedInteractor: ClientInteractor
    
    public init() {
        sharedInteractor = ClientInteractor.shared
    }
    
    // Client Info
    public func getClientInfo(requestId: String, callback: @escaping(Result<ClientInfoResponseEntity>) -> Void) {
        sharedInteractor.getClientInfo(requestId: requestId, callback: callback)
    }
}
