//
//  PasswordListViewModel.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 09/05/2021.
//

import Foundation
import KeychainSwift
import CoreHaptics
import SwiftUI

class PasswordListViewModel: ObservableObject {
    
    @Published var keys = [String]()
    @Published var usernames = [String]()
    @Published var showAnimation = false
    
    let separator = ":separator:"
    
    func saveToKeychain(password: String, username: String) {
        
        let key = password + separator + username
        
        keychain.set(password, forKey: key)
        successHaptic()
        showAnimation = true
        print("Saved to keychain")
        
    }
    
    func updatePassword(key: String, password: String) {
        keychain.set(password, forKey: key)
        print("password update")
    }
    
    func successHaptic() {
       let generator = UINotificationFeedbackGenerator()
       generator.notificationOccurred(.success)
       print("Simple haptic")
   }
    
    func getAllUsernames() {
        for key in keys {
            usernames =  key.components(separatedBy: separator)
        }
    }
    
    init() {
       keys = keychain.allKeys
    }
    
    @Published var keychain = KeychainSwift()
    
    func deletePassword(key: String) {
        keychain.delete(key)
    }
    
    func getAllKeys() {
        keys = keychain.allKeys
    }
}
