//
//  iCloudSyncToggle.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 08/07/2021.
//

import SwiftUI

struct iCloudSyncToggle: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var passwordViewModel: PasswordListViewModel
    
    var body: some View {
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
    }
}

struct iCloudSyncToggle_Previews: PreviewProvider {
    static var previews: some View {
        iCloudSyncToggle(settingsViewModel: SettingsViewModel(), passwordViewModel: PasswordListViewModel())
    }
}
