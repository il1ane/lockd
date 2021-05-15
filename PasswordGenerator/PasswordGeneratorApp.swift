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
    
    var body: some Scene {
        WindowGroup {
            
            if settingsViewModel.isUnlocked {
            MainView(viewModel: settingsViewModel)
                
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .accentColor(settingsViewModel.colors[settingsViewModel.accentColorIndex])
                .preferredColorScheme(.dark)
        
            }
            
            if !settingsViewModel.isUnlocked {
                LoggingView(viewModel: settingsViewModel, biometricType: settingsViewModel.biometricType())
                    .accentColor(.green)
                    .preferredColorScheme(.dark)
                    .onAppear(perform: {
                        
                        if settingsViewModel.faceIdDefault == false {
                            settingsViewModel.isUnlocked = true
                            print("No biometric authentication")
                        }
                        
                        if settingsViewModel.faceIdDefault == true {
                            settingsViewModel.authenticate()
                            print("Biometric authentication")
                        }
                })
            }
        }
    }
}
