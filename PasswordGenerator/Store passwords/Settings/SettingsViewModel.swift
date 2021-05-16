//
//  SettingsViewModel.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import Foundation
import SwiftUI
import LocalAuthentication

class SettingsViewModel: ObservableObject {
    
    @Published var isUnlocked = false
    
    @AppStorage("isDarkMode") var appAppearance: String = "Auto"
    
    @Published var appAppearanceToggle: Bool = false
    
    @Published var accentColorIndex: Int {
        didSet {
            UserDefaults.standard.set(accentColorIndex, forKey: "accentColorIndex")
        }
    }
    
    @Published var faceIdToggle: Bool {
        didSet {
            UserDefaults.standard.set(faceIdToggle, forKey: "faceIdToggle")
        }
    }
    
    @Published var faceIdDefault: Bool {
        didSet {
            UserDefaults.standard.set(faceIdDefault, forKey: "biometricAuthentication")
        }
    }
        init() {
        self.faceIdDefault = UserDefaults.standard.object(forKey: "biometricAuthentication") as? Bool ?? true
        self.faceIdToggle = UserDefaults.standard.object(forKey: "faceIdToggle") as? Bool ?? true
        self.accentColorIndex = UserDefaults.standard.object(forKey: "accentColorIndex") as? Int ?? 0
        }
    
    let colors = [Color.green, Color.blue, Color.red, Color.pink, Color.purple, Color.yellow]
   
    
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
                let reason = "Déverouiller vos mots de passe"
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
            let reason = "Sécurisez vos mots de passes avec l'authentication biometrique."
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

