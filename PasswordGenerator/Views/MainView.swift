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
    
    var body: some View {
        
        if settingsViewModel.isUnlocked {
            
            if settingsViewModel.isHiddenInAppSwitcher {
                PrivacyView()
            }
            
            else {
            TabViews(settingsViewModel: settingsViewModel, passwordListViewModel: passwordViewModel, passwordGeneratorViewModel: passwordGeneratorViewModel)
            }
        }
        
        else if !settingsViewModel.isUnlocked {
            
            AuthenticationView(viewModel: settingsViewModel, biometricType: settingsViewModel.biometricType(), passwordViewModel: passwordViewModel, settingsViewModel: settingsViewModel)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(settingsViewModel: SettingsViewModel(), passwordViewModel: PasswordListViewModel(), passwordGeneratorViewModel: PasswordGeneratorViewModel())
    }
}
