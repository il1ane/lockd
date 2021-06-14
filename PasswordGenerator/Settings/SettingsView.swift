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
                
                            Toggle(isOn: $settingsViewModel.faceIdToggle,
                                   label: {
                                Label(title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("Déverouiller avec votre mot de passe") },
                                      icon: { biometricType == .face ? Image(systemName: "faceid") : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "key.fill") }
                                )
                            }).toggleStyle(SwitchToggleStyle(tint: settingsViewModel.colors[settingsViewModel.accentColorIndex]))
                            
                            .onChange(of: settingsViewModel.faceIdToggle, perform: { _ in
                                
                                if settingsViewModel.faceIdToggle {
                                    settingsViewModel.addBiometricAuthentication()
                                    print("Waiting for auth")
                                }
                                
                                if !settingsViewModel.faceIdToggle {
                                    settingsViewModel.turnOffBiometricAuthentication()
                                }
                            })
                            
                            if settingsViewModel.faceIdDefault {
                                Picker(selection: $settingsViewModel.autoLock, label: Label(
                                    title: { Text("Vérouillage auto.") },
                                    icon: { Image(systemName: "lock.fill") }),
                                    content: {
                                    Text("Immédiat").tag(0)
                                    Text("1 minute").tag(1)
                                    Text("5 minutes").tag(5)
                                    Text("15 minutes").tag(15)
                                    Text("30 minutes").tag(30)
                                })
                            }
                            
                            Toggle(isOn: $passwordViewModel.keychainSyncWithIcloud, label: {
                                Label(
                                    title: { Text("iCloud keychain") },
                                    icon: { Image(systemName: "key.icloud.fill") }
                                )
                            })
                            .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.colors[settingsViewModel.accentColorIndex]))
                            
                            .onChange(of: passwordViewModel.keychainSyncWithIcloud, perform: { value in
                                if passwordViewModel.keychainSyncWithIcloud {
                                    passwordViewModel.keychain.synchronizable = true
                                    print("iCloud sync on")
                                } else {
                                    passwordViewModel.keychain.synchronizable = false
                                    print("iCloud sync turned off")
                                }
                            })
                            
                            Toggle(isOn: $settingsViewModel.privacyMode,
                                   label: {
                                Label(title: { Text("Cacher dans le multitâche") },
                                      icon: { Image(systemName: "eye.slash") })
                            })
                            .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.colors[settingsViewModel.accentColorIndex]))
                        }
 
                        Section(header: Text("Liens")) {
                            
                            Link(destination: URL(string: "https://github.com/il1ane/PasswordGenerator")!) {
                                Label(title: { Text("Code source (GitHub)") },
                                      icon: { Image(systemName: "chevron.left.slash.chevron.right") }) }
                            
                            Link(destination: URL(string: "https://twitter.com/il1ane")!) {
                                Label(title: { Text("Suivez moi sur Twitter") },
                                      icon: { Image(systemName: "heart.fill") }) }
                            
                            Button(action: { settingsViewModel.requestAppStoreReview() },
                                   label:
                                   Label(title: { Text("Noter sur l'App Store") },
                                         icon: { Image(systemName: "star.fill") }))
                        }
                        
                        Section(footer:
                                    VStack {
                                        Spacer().frame(height: 5)
                                        HStack {
                                            Spacer()
                                            Text("beta")
                                            Spacer()
                                        }}) {
                            Button(action: { removePasswordAlert.toggle() }, label: {
                                Label(
                                    title: { Text("Effacer tous les mots de passes").foregroundColor(.red)},
                                    icon: { Image(systemName: "trash.fill").foregroundColor(.red)
                                    }
                                )
                            }).buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .onAppear(perform: {
                    biometricType = settingsViewModel.biometricType() })
                .navigationBarTitle("Préférences")
                
                .alert(isPresented: $removePasswordAlert, content: {
                    Alert(title: Text("Effacer TOUS les mots de passes"),
                          message: Text("Vos mots de passes seront supprimés de manière définitive. Cette action est irreversible."),
                          primaryButton: .cancel(),
                          secondaryButton: .destructive(Text("TOUT supprimer"),
                          action: {
                           keychain.clear()
                           passwordViewModel.addedPasswordHaptic()
                          }))
                })
            }
        }.accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settingsViewModel: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.face, passwordViewModel: PasswordListViewModel())
    }
}
