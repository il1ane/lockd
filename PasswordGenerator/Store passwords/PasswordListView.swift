//
//  PasswordListView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI
import Security

struct PasswordListView: View {
    
    let passwordsNames = ["Facebook", "Twitter", "Instagram", "Snapchat", "Google", "Apple", "Spotify", "Mail", "Twitch", "League of Legends"]
    
    var body: some View {
         
        NavigationView {
            List(passwordsNames, id: \.self) { password in
                Text(password)
                
            }.navigationBarTitle("Coffre fort")
        }
    }
}

struct PasswordListView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordListView()
    }
}
