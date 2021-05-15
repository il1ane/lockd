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
    
    @Published var faceIdToggle: Bool {
        didSet {
            UserDefaults.standard.set(faceIdDefault, forKey: "biometricAuthentication")
        }
    }
    
    @Published var faceIdDefault: Bool {
        didSet {
            UserDefaults.standard.set(faceIdDefault, forKey: "biometricAuthentication")
        }
    }
        init() {
        self.faceIdDefault = UserDefaults.standard.object(forKey: "biometricAuthentication") as? Bool ?? true
        self.faceIdToggle = UserDefaults.standard.object(forKey: "biometricAuthentication") as? Bool ?? true
        }
    
    let colors = [Color.green, Color.blue, Color.red, Color.pink, Color.purple, Color.yellow]
    
    func updateColor(color: Color) {
accentColor = color
    }
    
    //check if device have touchID, faceID or no biometric activated
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
                            self.isUnlocked = false
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
                        self.faceIdDefault = true
                        
                    } else {
                        self.faceIdToggle = false
                        self.faceIdDefault = false
                        print("Failed to authenticate")
                    }
                }
            }
        } else {
            print("No biometrics")
            self.faceIdDefault = false
            
    }
}
    
    func turnOffBiometricAuthentication() {
        self.faceIdDefault = false
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
