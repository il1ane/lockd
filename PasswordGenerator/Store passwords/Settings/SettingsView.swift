//
//  SettingsView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings: SettingsViewModel
    @State private var selectedColor = Colors.green
    @State var biometricType: SettingsViewModel.BiometricType
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Sécurité")) {
                        
                        if settings.biometricType() != .none {
                            Toggle(isOn: $settings.faceIdToggle, label: {
                                Label(
                                    title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("") },
                                    icon: { biometricType == .face ? Image(systemName: "faceid") : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "") }
                                )
                            }).onChange(of: settings.faceIdToggle, perform: { _ in
                                
                                if settings.faceIdToggle {
                                   settings.addBiometricAuthentication()
                                    print("Waiting for auth")
                                }
                                
                                if !settings.faceIdToggle {
                                    settings.turnOffBiometricAuthentication()
                                }
                                
                            })
                        }
                    }
                }
            }
    
            .onAppear(perform: {
            //set biometric type for device
            biometricType = settings.biometricType()
            })
            
            
            
         .navigationBarTitle("Préférences")
        }.accentColor(settings.accentColor)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.face)
    }
}
