//
//  MainView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 07/05/2021.
//

import SwiftUI
import LocalAuthentication

struct MainView: View {
    
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        
        
        VStack {
            TabView(
                content:  {
                    PasswordGeneratorView(settings: viewModel).tabItem { Label(
                        title: { Text("Générateur") },
                        icon: { Image(systemName: "rectangle.and.pencil.and.ellipsis") }
                    ).padding() }.tag(0)
                    PasswordListView(viewModel: PasswordListViewModel(), settings: viewModel).tabItem { Label(
                        title: { Text("Coffre fort") },
                        icon: { Image(systemName: "tray.2") }
                    ).padding() }.tag(1)
                    SettingsView( settings: viewModel, biometricType: viewModel.biometricType() ).tabItem { Label(
                        title: { Text("Préfèrences") },
                        icon: { Image(systemName: "gear") }
                        
                    ).padding() }.tag(2)
                })
        }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            if viewModel.faceIdDefault {
            viewModel.isUnlocked = false
            }
        }
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: SettingsViewModel())
    }
}
