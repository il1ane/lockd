//
//  SettingsView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import SwiftUI
import KeychainSwift

struct SettingsView: View {
    
    @ObservedObject var settings: SettingsViewModel
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
                            
                            
                            Toggle(isOn: $settings.faceIdToggle, label: {
                                Label(
                                    title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("Déverouiller avec votre mot de passe") },
                                    icon: { biometricType == .face ? Image(systemName: "faceid") : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "key.fill") }
                                )
                            }).toggleStyle(SwitchToggleStyle(tint: settings.colors[settings.accentColorIndex]))
                            
                            .onChange(of: settings.faceIdToggle, perform: { _ in
                                
                                if settings.faceIdToggle {
                                    settings.addBiometricAuthentication()
                                    print("Waiting for auth")
                                }
                                
                                if !settings.faceIdToggle {
                                    settings.turnOffBiometricAuthentication()
                                }
                                
                            })
                            
                            .onChange(of: settings.autoLock, perform: {_ in
                                print(settings.autoLock)
                                
                            })
                            
                            if settings.faceIdDefault {
                                Picker(selection: $settings.autoLock, label: Label(
                                    title: { Text("Vérouillage auto.") },
                                    icon: { Image(systemName: "lock.fill") }
                                ), content: {
                                    
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
                            }).toggleStyle(SwitchToggleStyle(tint: settings.colors[settings.accentColorIndex]))
                            .onChange(of: passwordViewModel.keychainSyncWithIcloud, perform: { value in
                                if passwordViewModel.keychainSyncWithIcloud {
                                    passwordViewModel.keychain.synchronizable = true
                                    print("iCloud sync on")
                                } else {
                                    passwordViewModel.keychain.synchronizable = false
                                    print("iCloud sync turned off")
                                }
                            })
                            
                            Toggle(isOn: $settings.privacyMode, label: {
                                Label(
                                    title: { Text("Cacher dans le multitâche") },
                                    icon: { Image(systemName: "eye.slash") }
)
                                
                            }).toggleStyle(SwitchToggleStyle(tint: settings.colors[settings.accentColorIndex]))
                            
                        }
                        
                        
//                        Section(header: Text("Personalisation (readabilty issues?)")) {
//                            Picker(selection: $settings.accentColorIndex, label: Label(
//                                title: { Text("Couleur principale") },
//                                icon: { Image(systemName: "eyedropper.halffull") }
//                            )             , content: {
//                                
//                                List {
//                                    Label(
//                                        title: { Text("Vert") },
//                                        icon: { Image(systemName: "circle.fill")
//                                            .foregroundColor(settings.colors[0])
//                                            
//                                        }).tag(0)
//                                    
//                                    Label(
//                                        title: { Text("Bleu") },
//                                        icon: { Image(systemName: "circle.fill")
//                                            .foregroundColor(settings.colors[1])
//                                            
//                                        }).tag(1)
//                                    
//                                    Label(
//                                        title: { Text("Orange") },
//                                        icon: { Image(systemName: "circle.fill")
//                                            .foregroundColor(settings.colors[2])
//                                            
//                                        }).tag(2)
//                                    
//                                    Label(
//                                        title: { Text("Rose") },
//                                        icon: { Image(systemName: "circle.fill")
//                                            .foregroundColor(settings.colors[3])
//                                            
//                                        }).tag(3)
//                                    
//                                    Label(
//                                        title: { Text("Violet") },
//                                        icon: { Image(systemName: "circle.fill")
//                                            .foregroundColor(settings.colors[4])
//                                            
//                                        }).tag(4)
//                                    
//                                    Label(
//                                        title: { Text("Jaune") },
//                                        icon: { Image(systemName: "circle.fill")
//                                            .foregroundColor(settings.colors[5])
//                                            
//                                        }).tag(5)
//                                }
//                                
//                            })
                            
                            //override dark mode settings feature
                            
                            //                        Picker(selection: settings.$appAppearance, label: Label(
                            //                            title: { HStack {
                            //                                Text("Mode nuit")
                            //
                            //                            } },
                            //                            icon: {
                            //
                            //                                if settings.appAppearance == "Auto" {
                            //                                    Image(systemName: "moon.circle")
                            //                                }
                            //                                if settings.appAppearance == "Nuit" {
                            //                                    Image(systemName: "moon.fill")
                            //                                }
                            //                                if settings.appAppearance == "Jour" {
                            //                                    Image(systemName: "sun.min")
                            //                                }
                            //
                            //                            }
                            //                        ), content: {
                            //                            Text("Automatique").tag("Auto")
                            //                            Text("Nuit").tag("Nuit")
                            //                            Text("Jour").tag("Jour")
                            //                        }).pickerStyle(MenuPickerStyle()).onChange(of: settings.appAppearance, perform: { value in
                            //                            if settings.appAppearance == "Nuit" {
                            //                                settings.appAppearanceToggle = true
                            //                            } else if settings.appAppearance == "Jour" {
                            //                                settings.appAppearanceToggle = false
                            //                            }
                            //                        })
                            
//                        }
                        
                        Section(header: Text("Liens")) {
                            Link(destination: URL(string: "https://github.com/il1ane/PasswordGenerator")!) {
                                
                                Label(
                                    title: { Text("Code source (GitHub)") },
                                    icon: { Image(systemName: "chevron.left.slash.chevron.right") }
                                )
                            }
                            
                            Link(destination: URL(string: "https://twitter.com/il1ane")!) {
                                
                                Label(
                                    title: { Text("Suivez moi sur Twitter") },
                                    icon: { Image(systemName: "heart.fill") }
                                )
                            }
                            
                            
                            
                        }
                        
                        Section(footer:
                                    
                                    VStack {
                                        Spacer()
                                            .frame(height: 5)
                                        HStack {
                                            Spacer()
                                            Text("beta")
                                            Spacer()
                                        }
                                    }) {
                            Button(action: { removePasswordAlert.toggle() }, label: {
                                Label(
                                    title: { Text("Effacer tous les mots de passes").foregroundColor(.red)},
                                    icon: { Image(systemName: "trash.fill").foregroundColor(.red)
                                    }
                                )
                            })
                            .buttonStyle(PlainButtonStyle())
                        }
                        
                    }
                    
                }
                
                .alert(isPresented: $removePasswordAlert, content: {
                    Alert(title: Text("Effacer TOUS les mots de passes"), message: Text("Vos mots de passes seront supprimés de manière définitive. Cette action est irreversible."), primaryButton: .cancel(), secondaryButton: .destructive(Text("TOUT supprimer"), action: {
                        keychain.clear()
                        passwordViewModel.addedPasswordHaptic()
                    }))
                })
                
                .onAppear(perform: {
                    //set biometric type for device
                    biometricType = settings.biometricType()
                })
                
                
                
                .navigationBarTitle("Préférences")
            }
        }.accentColor(settings.colors[settings.accentColorIndex])
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(settings: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.face, passwordViewModel: PasswordListViewModel())
    }
}
