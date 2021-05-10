//
//  SettingsViewModel.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import Foundation
import SwiftUI
import LocalAuthentication
import Combine

class SettingsViewModel: ObservableObject {

    @Published var isUnlocked = false
    @Published var accentColor = Color.green
    @Published var useFaceId: Bool {
        didSet {
            UserDefaults.standard.set(useFaceId, forKey: "biometricAuthentication")
        }
    }
        init() {
        self.useFaceId = UserDefaults.standard.object(forKey: "biometricAuthentication") as? Bool ?? true
        }
    
    let colors = [Color.green, Color.blue, Color.red, Color.pink, Color.purple, Color.yellow]
    
    func updateColor(color: Color) {
accentColor = color
    }
    
     func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch(authContext.biometryType) {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            @unknown default:
                return .unknown
            }
        } else {
            return authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touch : .none
        }
    }

    enum BiometricType {
        case none
        case touch
        case face
        case unknown
    }
    
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "We need to unlock your data."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            self.isUnlocked = true
                            print("Success")
                            
                        } else {
                            print("Failed to authenticate")
                        }
                    }
                }
            } else {
                print("No biometrics")
        }
    }
    
    func addBiometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("Success")
                        self.useFaceId = true
                        
                    } else {
                       
                        self.useFaceId = false
                        print("Failed to authenticate")
                    }
                }
            }
        } else {
            print("No biometrics")
            self.useFaceId = false
    }
  }
    
    func turnOffBiometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("Successfully turned off biometric authentication")
                        self.useFaceId = false
                        
                        
                    } else {
                        print("Something went wrong")
                    }
                }
            }
        } else {
            print("No biometrics")
            
    }
  }
}
    



enum Colors: String, Identifiable, CaseIterable{
    case green
    case blue
    case red
    case pink
    case purple
    case yellow
    
    var id: String { self.rawValue }
}
