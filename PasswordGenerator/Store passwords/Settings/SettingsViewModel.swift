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
    @Published var accentColor = Color.green
    
    let defaults = UserDefaults.standard
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
                            
                        } else {
                            //error
                        }
                    }
                }
            } else {
                //no biometric
                    
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
