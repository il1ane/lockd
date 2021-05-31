//
//  SettingsViewModel.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import Foundation
import SwiftUI
import LocalAuthentication
import CoreHaptics

final class SettingsViewModel: ObservableObject {
    
    init() {
    self.faceIdDefault = UserDefaults.standard.object(forKey: "biometricAuthentication") as? Bool ?? false
    self.faceIdToggle = UserDefaults.standard.object(forKey: "faceIdToggle") as? Bool ?? false
    self.accentColorIndex = UserDefaults.standard.object(forKey: "accentColorIndex") as? Int ?? 1
    supportsHaptics = hapticCapability.supportsHaptics
    self.isFirstLaunch = UserDefaults.standard.object(forKey: "isFirstLaunch") as? Bool ?? true
    self.autoLock = UserDefaults.standard.object(forKey: "autoLock") as? Int ?? 1
    }

    
    var supportsHaptics: Bool = false
    let hapticCapability = CHHapticEngine.capabilitiesForHardware() 
    
    
    
    

    @Published var isUnlocked = false
    @Published var lockAppTimerIsRunning = false
    @AppStorage("isDarkMode") var appAppearance: String = "Auto"
    @AppStorage("appAppearanceToggle") var appAppearanceToggle: Bool = false
    
    @Published var autoLock: Int {
        didSet {
            UserDefaults.standard.set(autoLock, forKey: "autoLock")
        }
    }
    
    @Published var isFirstLaunch: Bool {
        didSet {
            UserDefaults.standard.set(isFirstLaunch, forKey: "isFirstLaunch")
        }
    }
    
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
       
    let colors = [Color.green, Color.blue, Color.red, Color.pink, Color.purple, Color.yellow]
   
    
    //check if device have touchID, faceID or no biometric activated
     func biometricType() -> BiometricType {
        let authContext = LAContext()
        if #available(iOS 11, *) {
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
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
            return authContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) ? .touch : .none
        }
    }

    enum BiometricType {
        case none
        case touch
        case face
        case unknown
    }
    
        func biometricAuthentication() -> Bool {
            var getKeychainItems = false
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
                let reason = "Déverouiller vos mots de passe"
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            print("success")
                           self.isUnlocked = true
                           getKeychainItems = true
                            
                            
                        } else {
                            self.isUnlocked = false
                            print("Failed to authenticate")
                        }
                    }
                }
            } else {
                print("No biometrics")
    }
            return getKeychainItems
}
    
    func addBiometricAuthentication() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Sécurisez vos mots de passes."
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
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
    
    func lockAppInBackground() {
        
        lockAppTimerIsRunning = true
        let seconds:Int = autoLock * 60
        let dispatchAfter = DispatchTimeInterval.seconds(seconds)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + dispatchAfter) {
            if self.lockAppTimerIsRunning {
            self.isUnlocked = false
                print("App is locked")
            }
        }
    }

}

