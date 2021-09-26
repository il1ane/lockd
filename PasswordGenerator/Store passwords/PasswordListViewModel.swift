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
        
        if keychain.set(password, forKey: key) {
            addedPasswordHaptic()
            showAnimation = true
            print("Successfully saved to Keychain")
        } else {
            print("Error saving to Keychain")
        }
    }
    
    func updatePassword(key: String, newPassword: String) {
        if keychain.set(newPassword, forKey: key, withAccess: .accessibleWhenUnlocked) {
            print("Successfully updated password")
        } else {
            print("Error updating password")
        }
    }
    
    func updateUsername(key: String, password: String, newUsername: String, title: String) -> String {
        
        let newKey = title + separator + newUsername
        
        if keychain.delete(key) {
            if keychain.set(password, forKey: newKey, withAccess: .accessibleWhenUnlocked) {
                print("Username successfully updated")
            } else {
                print("Error updating username")
            }
        } else {
            print("failed to delete key")
        }
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
    
    func getPasswordHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1)
       print("Simple haptic")
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
        if keychain.delete(key) {
            print("Successfully deleted")
        } else {
            print("Error deleting password")
        }
    }
    
    func deleteFromList(offsets: IndexSet) {
        for offset in offsets {
            let keyToDelete = keys[offset]
            deletePassword(key: keyToDelete)
            
            //delay before refreshing keys because of an animation glich in list 
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                self.getAllKeys()
            }
        }
    }
    
    func getAllKeys() {
        if sortSelection == 0 {
            keys = keychain.allKeys.sorted()
        } else {
            keys = keychain.allKeys.sorted().reversed()
        }
    }
}
