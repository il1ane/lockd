//
//  TabView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/07/2021.
//

import SwiftUI

struct TabViews: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    @ObservedObject var passwordListViewModel: PasswordListViewModel
    @ObservedObject var passwordGeneratorViewModel:PasswordGeneratorViewModel
    
    var body: some View {
        
        VStack {
            TabView(content: {
                        
                        PasswordGeneratorView(settings: settingsViewModel,
                                              passwordViewModel: passwordListViewModel)
    
                            .tabItem {
                                
                                Label(title: { Text("Générateur") },
                                      icon: { Image(systemName: "die.face.5.fill") })
                                
                            }.tag(0)
                        
                        PasswordListView(passwordViewModel: passwordListViewModel,
                                         settings: settingsViewModel,
                                         passwordGeneratorViewModel: passwordGeneratorViewModel, settingsViewModel: settingsViewModel)
            
                            .tabItem {
                    
                                Label(title: { Text("Coffre fort") },
                                      icon: { Image(systemName: "lock.square") })
                                
                                
                            }.tag(1)
                        
                        SettingsView(settingsViewModel: settingsViewModel,
                                     biometricType: settingsViewModel.biometricType(),
                                     passwordViewModel: passwordListViewModel )
                
                            .tabItem {
                                
                                Label(title: { Text("Préférences") },
                                      icon: { Image(systemName: "gear") })
                                       .animation(.easeIn)
                                
                            }.tag(2) })
            
        }
    }
}

struct TabViews_Previews: PreviewProvider {
    static var previews: some View {
        TabViews(settingsViewModel: SettingsViewModel(), passwordListViewModel: PasswordListViewModel(), passwordGeneratorViewModel: PasswordGeneratorViewModel())
    }
}
