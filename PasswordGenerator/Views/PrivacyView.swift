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
            if #available(iOS 15.0, *) {
                LinearGradient(colors: [.blue], startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.blue.edgesIgnoringSafeArea(.all)
                // Fallback on earlier versions
            }
            
            Image(systemName: "eye.slash")
                .foregroundColor(.white)
                .font(.system(size: 80))
        }
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
