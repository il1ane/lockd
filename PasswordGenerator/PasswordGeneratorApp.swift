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
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                if settingsViewModel.privacyMode {
                settingsViewModel.hideInAppSwitcher = false
                }
                print("App is in inactive phase")
            } else if newPhase == .active {
                if settingsViewModel.privacyMode {
                settingsViewModel.hideInAppSwitcher = false
                }
                settingsViewModel.lockAppTimerIsRunning = false
                print("App is in active phase")
            } else if newPhase == .background {
                if settingsViewModel.privacyMode {
                settingsViewModel.hideInAppSwitcher = true
                }
                print("App is in background phase")
                if settingsViewModel.faceIdDefault {
                    settingsViewModel.lockAppInBackground()
                }
            }
        }
    }
}
