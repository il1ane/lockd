//
//  EphemeralClipboardToggle.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 08/07/2021.
//

import SwiftUI

struct EphemeralClipboardToggle: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        
        Toggle(isOn: $settingsViewModel.ephemeralClipboard, label: {
            Label(
                title: { Text("Presse papier éphémère") },
                icon: { Image(systemName: "doc.on.doc") })
        })
        .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.colors[settingsViewModel.accentColorIndex]))
        
    }
}

struct EphemeralClipboardToggle_Previews: PreviewProvider {
    static var previews: some View {
        EphemeralClipboardToggle(settingsViewModel: SettingsViewModel())
    }
}
