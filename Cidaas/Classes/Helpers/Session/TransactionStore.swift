//
//  TransactionStore.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

public class TransactionStore {
    public static let shared = TransactionStore()
    
    public var current: OAuthTransactionDelegate?
    
    public func resume(_ url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        let resumed = self.current?.resume(url, options: options) ?? false
        if resumed {
            self.current = nil
        }
        return resumed
    }
    
    public func store(_ transaction: OAuthTransactionDelegate) {
        self.current?.cancel()
        self.current = transaction
    }
    
    public func cancel(_ transaction: OAuthTransactionDelegate) {
        transaction.cancel()
        if self.current?.state == transaction.state {
            self.current = nil
        }
    }
    
    public func clear() {
        self.current = nil
    }
}
