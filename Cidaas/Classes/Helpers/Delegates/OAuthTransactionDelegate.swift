//
//  OAuthTransactionDelegate.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public protocol OAuthTransactionDelegate {
    var state: String? { get }
    func resume(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool
    func cancel()
}
