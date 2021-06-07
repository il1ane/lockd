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
    @Published var usernames = [String]()
    @Published var showAnimation = false
    @Published var sortSelection = 0

    
    let separator = ":separator:"
    
    func saveToKeychain(password: String, username: String, title: String) {
        
        let key = title + separator + username
        
        keychain.set(password, forKey: key)
        addedPasswordHaptic()
        showAnimation = true
        print("Saved to keychain")
        
    }
    
    func updatePassword(key: String, newPassword: String) {
        keychain.set(newPassword, forKey: key)
        print("password update")
    }
    
    func updateUsername(key: String, password: String, newUsername: String, title: String) -> String {
        keychain.delete(key)
        let newKey = title + separator + newUsername
        keychain.set(password, forKey: newKey)
        print("username update")
        return newKey
    }
    
    func addedPasswordHaptic() {
       let generator = UINotificationFeedbackGenerator()
       generator.notificationOccurred(.success)
       print("Simple haptic")
   }
    
    func deletedPasswordHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1)
       print("Simple haptic")
   }
    
    func getAllUsernames() {
        for key in keys {
            usernames =  key.components(separatedBy: separator)
        }
    }
    
    init() {
        self.keychainSyncWithIcloud = UserDefaults.standard.object(forKey: "keychainSyncWithIcloud") as? Bool ?? false
       keys = keychain.allKeys
    }
    
    @Published var keychain = KeychainSwift()
    
    @Published var keychainSyncWithIcloud: Bool {
        didSet {
            UserDefaults.standard.set(keychainSyncWithIcloud, forKey: "keychainSyncWithIcloud")
        }
    }
    
    func deletePassword(key: String) {
        keychain.delete(key)
    }
    
    func getAllKeys() {
        if sortSelection == 0 {
            keys = keychain.allKeys.sorted()
        } else {
            keys = keychain.allKeys.sorted().reversed()
        }
    }
}
