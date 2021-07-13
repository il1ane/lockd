//
//  UnlockMethodToggle.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 08/07/2021.
//

import SwiftUI

struct UnlockMethodToggle: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    var biometricType: SettingsViewModel.BiometricType
    
    var body: some View {
        Toggle(isOn: $settingsViewModel.faceIdToggle,
               label: {
                Label(title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("Déverouiller avec votre mot de passe") },
                      icon: { biometricType == .face ? Image(systemName: "faceid") : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "key.fill") }
                )
               })
            .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.colors[settingsViewModel.accentColorIndex]))
            
            .onChange(of: settingsViewModel.faceIdToggle, perform: { _ in
                
                if settingsViewModel.faceIdToggle {
                    settingsViewModel.addBiometricAuthentication()
                    print("Waiting for auth")
                }
                
                if !settingsViewModel.faceIdToggle {
                    settingsViewModel.turnOffBiometricAuthentication()
                }
            })
    }
}

struct UnlockMethodToggle_Previews: PreviewProvider {
    static var previews: some View {
        UnlockMethodToggle(settingsViewModel: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.face)
    }
}
