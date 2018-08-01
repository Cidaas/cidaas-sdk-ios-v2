//
//  TransactionStore.swift
//  sdkiOS
//
//  Created by ganesh on 25/07/18.
//  Copyright © 2018 Cidaas. All rights reserved.
//

import Foundation

class TransactionStore {
    static let shared = TransactionStore()
    
    private var current: OAuthTransactionDelegate?
    
    func resume(_ url: URL, options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool {
        let resumed = self.current?.resume(url, options: options) ?? false
        if resumed {
            self.current = nil
        }
        return resumed
    }
    
    func store(_ transaction: OAuthTransactionDelegate) {
        self.current?.cancel()
        self.current = transaction
    }
    
    func cancel(_ transaction: OAuthTransactionDelegate) {
        transaction.cancel()
        if self.current?.state == transaction.state {
            self.current = nil
        }
    }
    
    func clear() {
        self.current = nil
    }
}
