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
    @State private var biometricAuthentication = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Sécurité")) {
                        
                        Text("Rate app")
                        if settings.biometricType() != .none {
                            Toggle(isOn: $biometricAuthentication, label: {
                                Label(
                                    title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("") },
                                    icon: { biometricType == .face ? Image(systemName: "faceid") : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "") }
                                )
                            }).onChange(of: biometricAuthentication, perform: { value in
                                
                                if biometricAuthentication {
                                    settings.authenticate()
                                    print("Waiting for auth")
                                }
                                
                                if !biometricAuthentication {
                                    settings.defaults.setValue(false, forKey: "biometricAuthentication")
                                    print("Face ID turned off", settings.defaults.value(forKey: "biometricAuthentication")!)
                                }
                            })
                        }
                        
                        Text("Delete all passwords")
                    }
                    
                }.onChange(of: settings.isUnlocked, perform: { value in
                    
                    if settings.isUnlocked {
                            settings.defaults.setValue(true, forKey: "biometricAuthentication")
                        print("Face ID turned ON", settings.defaults.value(forKey: "biometricAuthentication")!)
                    }
                    
                    if !settings.isUnlocked {
                        settings.defaults.setValue(false, forKey: "biometricAuthentication")
                        print("Failed to authenticate")
                    }
                    
                })
                .onChange(of: settings.faceIdFail, perform: { value in
                    biometricAuthentication = false
                })
                
            }.onAppear(perform: {
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
