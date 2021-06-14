//
//  MainView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 07/05/2021.
//

import SwiftUI
import LocalAuthentication

struct MainView: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var passwordViewModel: PasswordListViewModel
    @ObservedObject var passwordGeneratorViewModel:PasswordGeneratorViewModel
    @State private var currentTab = 0
    @State private var onBoardingSheetIsPresented = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        
        if settingsViewModel.isUnlocked {
            
            if !settingsViewModel.hideInAppSwitcher {
            VStack {
                TabView(content: {
                    
                    PasswordGeneratorView(settings: settingsViewModel,
                                          passwordViewModel: passwordViewModel)
                        .onAppear(perform : { currentTab = 0 })
                        .tabItem {
                            Label(title: { Text("Générateur") },
                                  icon: { Image(systemName: "die.face.5.fill") })
                        }.tag(0)
                    
                    PasswordListView(passwordViewModel: passwordViewModel,
                                     settings: settingsViewModel, passwordGeneratorViewModel: passwordGeneratorViewModel)
                        .tabItem {
                            Label(title: { Text("Coffre fort") },
                                  icon: { Image(systemName: "lock.square") })
                            
                        }.tag(1)
                    
                    SettingsView(settingsViewModel: settingsViewModel,
                                 biometricType: settingsViewModel.biometricType(),
                                 passwordViewModel: passwordViewModel )
                        .tabItem {
                            Label(title: { Text("Préférences") },
                                  icon: { Image(systemName: "gear") })
                            
                        }.tag(2)
                })
            }
            .onAppear(perform: {
                if settingsViewModel.isFirstLaunch {
                    onBoardingSheetIsPresented = true
                }
            })
            
            .sheet(isPresented: $onBoardingSheetIsPresented, onDismiss: { settingsViewModel.isFirstLaunch = false } , content: {
                OnboardingView(settingsViewModel: settingsViewModel, isPresented: $onBoardingSheetIsPresented, biometricType: settingsViewModel.biometricType())
                    .environment(\.colorScheme, colorScheme)
            })
            } else if settingsViewModel.hideInAppSwitcher {
                PrivacyView()
            }


            
        } else {
            
            LoggingView(viewModel: settingsViewModel, biometricType: settingsViewModel.biometricType(), passwordViewModel: passwordViewModel)
                
                .onAppear(perform: {
                    
                    if settingsViewModel.faceIdDefault == false {
                        settingsViewModel.isUnlocked = true
                        passwordViewModel.getAllKeys()
                        print("No biometric authentication")
                    }
                    
                    if settingsViewModel.faceIdDefault == true {
                        if settingsViewModel.biometricAuthentication() {
                            passwordViewModel.getAllKeys()
                        }
                        print("Biometric authentication")
                    }
                })
            }
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(settingsViewModel: SettingsViewModel(), passwordViewModel: PasswordListViewModel(), passwordGeneratorViewModel: PasswordGeneratorViewModel())
    }
}
