//
//  PasswordGeneratorApp.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI

@main
struct PasswordGeneratorApp: App {
    let persistenceController = PersistenceController.shared
    @ObservedObject var settingsViewModel = SettingsViewModel()
    @ObservedObject var passwordViewModel = PasswordListViewModel()
    
    var body: some Scene {
        WindowGroup {
            
            
            
            if settingsViewModel.isUnlocked {
                
                MainView(settingsViewModel: settingsViewModel, passwordViewModel: passwordViewModel)
                
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
               // .colorScheme(settingsViewModel.appAppearanceToggle && settingsViewModel.appAppearance != "Auto" ? .dark : .light)
                
        
            }
            
            if !settingsViewModel.isUnlocked {
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
}
