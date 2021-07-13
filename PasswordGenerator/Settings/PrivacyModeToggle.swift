//
//  PrivacyModeToggle.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 08/07/2021.
//

import SwiftUI

struct PrivacyModeToggle: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    
    var body: some View {
        Toggle(isOn: $settingsViewModel.privacyMode,
               label: {
                Label(title: { Text("Cacher dans le multitâche") },
                      icon: { Image(systemName: "eye.slash") })
               })
            .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.colors[settingsViewModel.accentColorIndex]))
    }
}

struct PrivacyModeToggle_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyModeToggle(settingsViewModel: SettingsViewModel())
    }
}
