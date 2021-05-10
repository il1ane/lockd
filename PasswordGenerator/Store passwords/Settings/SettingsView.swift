//
//  SettingsView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings = SettingsViewModel()
    @State private var selectedColor = Colors.green
    @State var biometricType: SettingsViewModel.BiometricType
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Sécurité")) {
                        
                        if settings.biometricType() != .none {
                            Toggle(isOn: $settings.useFaceId, label: {
                                Label(
                                    title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("") },
                                    icon: { biometricType == .face ? Image(systemName: "faceid") : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "") }
                                )
                            }).onChange(of: settings.useFaceId, perform: { value in
                                
                                //When toggled on, try to add faceID or touch ID
                                if settings.useFaceId {
                                    settings.addBiometricAuthentication()
                                    print("Waiting for auth")
                                }
                                
                                //When toggled off, ask user to authenticate before turning off biometric authentication
                                else if !settings.useFaceId {
                                    settings.turnOffBiometricAuthentication()
                                    print("Waiting for auth")
                                }
                            })
                        }
                    }
                }
                
            }
            
            .onAppear(perform: {
                biometricType = settings.biometricType()
            })
            
            
            
            .navigationBarTitle("Préférences")
        }.accentColor(settings.accentColor)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(biometricType: SettingsViewModel.BiometricType.face)
    }
}
