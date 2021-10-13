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
    @State private var deletedPasswordsPopup = false
    
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
                                             passwordViewModel: passwordViewModel, deletedPasswordsPopup: $deletedPasswordsPopup)
                    }
                }
                
                .popup(isPresented: $deletedPasswordsPopup, type: .toast, position: .top, autohideIn: 2) {
                    VStack(alignment: .center) {
                        Spacer()
                            .frame(height: UIScreen.main.bounds.height / 22)
                        Label("Suppression effectuée", systemImage: "checkmark.circle.fill")
                        .opacity(1)
                        .padding(14)
                        .foregroundColor(Color.white)
                        .background(Color.blue)
                        .cornerRadius(30)
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

