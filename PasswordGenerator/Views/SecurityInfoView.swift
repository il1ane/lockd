//
//  SecurityInfoViewswift.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 25/09/2021.
//

import SwiftUI

struct SecurityInfoView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Robustesse d'un mot de passe")
                Text("Entropie")
                
            }
            .navigationTitle("Securité")
        }
    }
}

struct SecurityInfoViewswift_Previews: PreviewProvider {
    static var previews: some View {
        SecurityInfoView()
    }
}
