//
//  SettingsView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import SwiftUI
import KeychainSwift

struct SettingsView: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    @State var biometricType: SettingsViewModel.BiometricType
    let keychain = KeychainSwift()
    @State private var removePasswordAlert = false
    @ObservedObject var passwordViewModel: PasswordListViewModel
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                ZStack {

                    Form {
                        
                        Section(header: Text("Sécurité")) {
                            
                            UnlockMethodToggle(settingsViewModel: settingsViewModel,
                                               biometricType: biometricType)
                            
                            if settingsViewModel.unlockMethodIsActive {
                                
                                LockTimerPicker(settingsViewModel: settingsViewModel)
                                
                            }
                            
                            PrivacyModeToggle(settingsViewModel: settingsViewModel)
                            
                            //need testing before adding this feature
                            
                            //  iCloudSyncToggle(settingsViewModel: settingsViewModel, passwordViewModel: passwordViewModel)
                            
                        }
                        
                        Section(header: Text(""), footer: Text("Si cette option est active, le contenu du presse papier sera automatiquement supprimé après 60 secondes.")) {
                            
                            EphemeralClipboardToggle(settingsViewModel: settingsViewModel)
                            
                        }
                        
                        ExternalLinks(settingsViewModel: settingsViewModel)
                        
                        ClearPasswordsButton(removePasswordAlert: $removePasswordAlert,
                                             keychain: keychain,
                                             passwordViewModel: passwordViewModel)
                    }
                }
                .onAppear(perform: {
                    
                    biometricType = settingsViewModel.biometricType()
                    
                })
                
                .navigationBarTitle("Préférences")
            }
        }
        .accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsViewModel: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.face, passwordViewModel: PasswordListViewModel())
    }
}

