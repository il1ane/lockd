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
    @State private var currentTab = 0
    @State private var onBoardingSheetIsPresented = false
    @Environment(\.colorScheme) var colorScheme
    
   
    var body: some View {
        
        
        VStack {
           
            TabView(
                content:  {
                    
                    PasswordGeneratorView(settings: settingsViewModel, passwordViewModel: passwordViewModel)
                        .onAppear(perform : { currentTab = 0 })
                        .tabItem { Label(
                        title: { Text("Générateur") },
                        icon: { Image(systemName: "rectangle.and.pencil.and.ellipsis") }
                    ) }.tag(0)
                    PasswordListView(passwordViewModel: passwordViewModel, settings: settingsViewModel).tabItem { Label(
                        title: { Text("Coffre fort") },
                        icon: { Image(systemName: "tray.2") }
                    ) }.tag(1)
                    SettingsView( settings: settingsViewModel, biometricType: settingsViewModel.biometricType(), passwordViewModel: passwordViewModel ).tabItem { Label(
                        title: { Text("Préfèrences") },
                        icon: { Image(systemName: "gear") }
                        
                    ) }.tag(2)
                })
        }
        
        .onAppear(perform: {
            if settingsViewModel.isFirstLaunch {
                onBoardingSheetIsPresented = true
            }
        })
        
        .sheet(isPresented: $onBoardingSheetIsPresented, onDismiss: { settingsViewModel.isFirstLaunch = false } , content: {
            OnboardingView(settings: settingsViewModel, isPresented: $onBoardingSheetIsPresented)
                .environment(\.colorScheme, colorScheme)
        })
        
        
        
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            if settingsViewModel.faceIdDefault {
            settingsViewModel.isUnlocked = false
            }
        }
    }
    func setCurrentTab(tab: Int) {
        currentTab = tab
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(settingsViewModel: SettingsViewModel(), passwordViewModel: PasswordListViewModel())
    }
}
