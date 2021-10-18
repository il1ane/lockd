//
//  ViewExtensions.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 07/07/2021.
//

import SwiftUI

extension View {
    
    func animateForever(using animation: Animation = Animation.easeInOut(duration: 1), autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
        let repeated = animation.repeatForever(autoreverses: autoreverses)

        return onAppear {
            withAnimation(repeated) {
                action()
            }
        }
    }
    
    func adaptativeImage(biometricType: SettingsViewModel.BiometricType) -> String {
        
        switch biometricType {
        case .none:
            return "key"
        case .touch:
            return "touchid"
        case .face:
            return "faceid"
        case .unknown:
            return "key"
        }
    }
    
    func adaptativeMessage(biometricType: SettingsViewModel.BiometricType) -> LocalizedStringKey  {
        
        switch biometricType {
        case .none:
            return "Protégez vos mots de passes avec votre code de verouillage d'iPhone"
        case .touch:
            return "Protégez vos mots de passes avec Touch ID"
        case .face:
            return "Protégez vos mots de passes avec Face ID"
        case .unknown:
            return "Protégez vos mots de passes avec votre code de verouillage d'iPhone"
        }
    }
}
