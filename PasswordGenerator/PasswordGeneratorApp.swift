//
//  PasswordGeneratorApp.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI

@main
struct PasswordGeneratorApp: App {

    @ObservedObject var settingsViewModel = SettingsViewModel()
    @ObservedObject var passwordViewModel = PasswordListViewModel()
    @ObservedObject var passwordGeneratorViewModel = PasswordGeneratorViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        
        WindowGroup {
            
            MainView(settingsViewModel: settingsViewModel, passwordViewModel: passwordViewModel, passwordGeneratorViewModel: passwordGeneratorViewModel)
                .accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
                
                //Onboarding sheet
                .onAppear(perform: {
                    if settingsViewModel.isFirstLaunch {
                        settingsViewModel.onBoardingSheetIsPresented = true
                    }
                })
                
                .sheet(isPresented: $settingsViewModel.onBoardingSheetIsPresented, onDismiss: { settingsViewModel.isFirstLaunch = false } , content: {
                    OnboardingView(settingsViewModel: settingsViewModel, isPresented: $settingsViewModel.onBoardingSheetIsPresented, biometricType: settingsViewModel.biometricType())
                })
        }
        
        .onChange(of: scenePhase) { newPhase in
            
            if newPhase == .inactive {
                if settingsViewModel.privacyMode {
                settingsViewModel.isHiddenInAppSwitcher = false
                }
            }
            
            else if newPhase == .active {
                if settingsViewModel.privacyMode {
                settingsViewModel.isHiddenInAppSwitcher = false
                }
                settingsViewModel.lockAppTimerIsRunning = false
            }
            
            else if newPhase == .background {
                if settingsViewModel.privacyMode {
                settingsViewModel.isHiddenInAppSwitcher = true
                }
                if settingsViewModel.faceIdDefault {
                    settingsViewModel.lockAppInBackground()
                }
            }
            
        }
    }
}
