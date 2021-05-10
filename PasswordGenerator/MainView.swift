//
//  MainView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 07/05/2021.
//

import SwiftUI
import LocalAuthentication

struct MainView: View {
    
    @State private var isUnlocked = false
    @ObservedObject var viewModel = SettingsViewModel()
    
    var body: some View {
        
        
        
        VStack {
            if viewModel.isUnlocked {
            TabView(
                content:  {
                    PasswordGeneratorView().tabItem { Label(
                        title: { Text("Générateur") },
                        icon: { Image(systemName: "rectangle.and.pencil.and.ellipsis") }
                    ).padding() }.tag(0)
                    PasswordListView(viewModel: PasswordListViewModel()).tabItem { Label(
                        title: { Text("Coffre fort") },
                        icon: { Image(systemName: "tray.2") }
                    ).padding() }.tag(1)
                    SettingsView( biometricType: viewModel.biometricType() ).tabItem { Label(
                        title: { Text("Préfèrences") },
                        icon: { Image(systemName: "gear") }
                        
                    ).padding() }.tag(2)
                })
        } else {
            Text("🧐").font(.system(size: 100))
            Spacer()
        }
        }.onAppear(perform: {
            viewModel.authenticate()
    })
    }
}



struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
