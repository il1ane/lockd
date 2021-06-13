//
//  PrivacyView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 11/06/2021.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            Image(systemName: "eye.slash")
                .foregroundColor(.white)
                .font(.system(size: 80))
        }
        .animation(.easeIn)
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
