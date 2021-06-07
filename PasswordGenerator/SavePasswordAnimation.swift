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
                    .opacity(0.5)
                    .frame(minWidth: 150, maxWidth: 200, minHeight: 150, maxHeight: 200)
                      
                }
                    
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 70)).foregroundColor(.white)
                   
            }.transition(.scale)
            .animation(.easeIn(duration: 0.5))
        
    }
}

struct savePasswordAnimation_Previews: PreviewProvider {
    static var previews: some View {
        SavePasswordAnimation(settings: SettingsViewModel())
    }
}
