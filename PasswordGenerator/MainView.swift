//
//  MainView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 07/05/2021.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        TabView(
                content:  {
                    PasswordGeneratorView().tabItem { Label(
                        title: { Text("Générateur") },
                        icon: { Image(systemName: "rectangle.and.pencil.and.ellipsis") }
                    ).padding() }.tag(1)
                    PasswordListView().tabItem { Label(
                        title: { Text("Coffre fort") },
                        icon: { Image(systemName: "tray.2") }
                    ).padding() }.tag(2)
                })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
