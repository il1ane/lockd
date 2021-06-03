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

final class PasswordListViewModel: ObservableObject {
    
    @Published var keys = [String]()
    @Published var usernames = [String]().sorted()
    @Published var showAnimation = false
    
    let separator = ":separator:"
    
    func saveToKeychain(password: String, username: String, title: String) {
        
        let key = password + separator + username + separator + title
        
        keychain.set(password, forKey: key)
        successHaptic()
        showAnimation = true
        print("Saved to keychain")
        
    }
    
    func updatePassword(key: String, newPassword: String) {
        keychain.set(newPassword, forKey: key)
        print("password update")
    }
    
    func updateUsername(key: String, password: String, newUsername: String, title: String) -> String {
        keychain.delete(key)
        let newKey = password + separator + newUsername + separator + title
        keychain.set(password, forKey: newKey)
        print("username update")
        return newKey
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
        keys = keychain.allKeys.sorted()
    }
}
