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
    @ObservedObject var passwordViewModel: PasswordListViewModel
    @State private var currentTab = 0
   
    var body: some View {
        
        
        VStack {
            
            TabView(
                content:  {
                    
                    PasswordGeneratorView(settings: viewModel, passwordViewModel: passwordViewModel)
                        .onAppear(perform : { currentTab = 0 })
                        .tabItem { Label(
                        title: { Text("Générateur") },
                        icon: { Image(systemName: "rectangle.and.pencil.and.ellipsis") }
                    ).padding() }.tag(0)
                    PasswordListView(passwordViewModel: passwordViewModel, settings: viewModel).tabItem { Label(
                        title: { Text("Coffre fort") },
                        icon: { Image(systemName: "tray.2") }
                    ).padding() }.tag(1)
                    SettingsView( settings: viewModel, biometricType: viewModel.biometricType() ).tabItem { Label(
                        title: { Text("Préfèrences") },
                        icon: { Image(systemName: "gear") }
                        
                    ).padding() }.tag(2)
                })
        }
        
        
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            if viewModel.faceIdDefault {
            viewModel.isUnlocked = false
            }
        }
    }
    func setCurrentTab(tab: Int) {
        currentTab = tab
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: SettingsViewModel(), passwordViewModel: PasswordListViewModel())
    }
}
