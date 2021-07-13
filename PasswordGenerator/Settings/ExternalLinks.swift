//
//  ExternalLinks.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 08/07/2021.
//

import SwiftUI

struct ExternalLinks: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        Section(header: Text("Liens")) {
            
            Link(destination: URL(string: "https://github.com/il1ane/PasswordGenerator")!) {
                
                Label(title: { Text("Code source (GitHub)") },
                      icon: { Image(systemName: "chevron.left.slash.chevron.right") }) }
            
            Link(destination: URL(string: "https://twitter.com/lockd_app")!) {
                    
                Label(title: { Text("Suivez nous sur Twitter") },
                      icon: { Image(systemName: "heart.fill") }) }
            
            Button(action: { settingsViewModel.requestAppStoreReview() },
                   label:
                    Label(title: { Text("Noter sur l'App Store") },
                          icon: { Image(systemName: "star.fill") }))
        }
    }
}

struct ExternalLinks_Previews: PreviewProvider {
    static var previews: some View {
        ExternalLinks(settingsViewModel: SettingsViewModel())
    }
}
