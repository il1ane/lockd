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
    @State private var currentTab = 0
    @State private var onBoardingSheetIsPresented = false
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    
   
    var body: some View {
        
        
        if settingsViewModel.isUnlocked {
        VStack {
           
            TabView(
                content:  {
                    
                    PasswordGeneratorView(settings: settingsViewModel, passwordViewModel: passwordViewModel)
                        .onAppear(perform : { currentTab = 0 })
                        .tabItem { Label(
                        title: { Text("Générateur") },
                        icon: { Image(systemName: "die.face.5.fill") }
                    ) }.tag(0)
                    PasswordListView(passwordViewModel: passwordViewModel, settings: settingsViewModel).tabItem { Label(
                        title: { Text("Mots de passe") },
                        icon: { Image(systemName: "tray.2.fill") }
                    ) }.tag(1)
                    SettingsView( settings: settingsViewModel, biometricType: settingsViewModel.biometricType(), passwordViewModel: passwordViewModel ).tabItem { Label(
                        title: { Text("Préférences") },
                        icon: { Image(systemName: "gear") }
                        
                    ) }.tag(2)
                })
        }
        
        
        .onAppear(perform: {
            if settingsViewModel.isFirstLaunch {
                onBoardingSheetIsPresented = true
            }
        })
        
        .sheet(isPresented: $onBoardingSheetIsPresented, onDismiss: { settingsViewModel.isFirstLaunch = false } , content: {
            OnboardingView(settings: settingsViewModel, isPresented: $onBoardingSheetIsPresented)
                .environment(\.colorScheme, colorScheme)
        })
        
        .onChange(of: scenePhase) { newPhase in
                        if newPhase == .inactive {
                            print("App is in inactive phase")
                        } else if newPhase == .active {
                            settingsViewModel.lockAppTimerIsRunning = false
                            print("App is in active phase")
                        } else if newPhase == .background {
                            print("App is in background phase")
                            if settingsViewModel.faceIdDefault {
                                settingsViewModel.lockAppInBackground()
                            }
                        }
                    }
        
        
        } else {
            
            LoggingView(viewModel: settingsViewModel, biometricType: settingsViewModel.biometricType(), passwordViewModel: passwordViewModel)
                .colorScheme(settingsViewModel.appAppearanceToggle && settingsViewModel.appAppearance != "Auto" ? .dark : .light)
                
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
        MainView(settingsViewModel: SettingsViewModel(), passwordViewModel: PasswordListViewModel())
    }
}
