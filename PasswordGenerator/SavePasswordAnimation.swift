//
//  savePasswordAnimation.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 18/05/2021.
//

import SwiftUI

struct SavePasswordAnimation: View {
    
    @ObservedObject var settings: SettingsViewModel

    var body: some View {
        
        ZStack {
            
            VStack {
                
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(settings.appAppearance == "Nuit" ? .black : .gray)
                .opacity(0.5)
                .frame(width: 200, height: 200)
                
                
                

                
                
            }
                
            Image(systemName: "checkmark.circle")
                .font(.system(size: 70)).foregroundColor(.white)
               
        }
    }
}

struct savePasswordAnimation_Previews: PreviewProvider {
    static var previews: some View {
        SavePasswordAnimation(settings: SettingsViewModel())
    }
}
