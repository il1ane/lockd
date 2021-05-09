//
//  PasswordListViewModel.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 09/05/2021.
//

import Foundation
import KeychainSwift

class PasswordListViewModel: ObservableObject {
    
    @Published var keys = [String]()
    
    init() {
       keys = keychain.allKeys
    }
    
    @Published var keychain = KeychainSwift()
    func deletePassword(key: String) {
        keychain.delete(key)
    }
    
    func refreshKeys() {
        keys = keychain.allKeys
    }
}
