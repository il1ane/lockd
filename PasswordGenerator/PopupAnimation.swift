//
//  savePasswordAnimation.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 18/05/2021.
//

import SwiftUI

struct PopupAnimation: View {
    
    @ObservedObject var settings: SettingsViewModel
    let message:LocalizedStringKey

    var body: some View {
        
        
            ZStack {
                VStack {
                RoundedRectangle(cornerRadius: 20)
                    .opacity(0.7)
                    .frame(minWidth: 150, maxWidth: 200, minHeight: 150, maxHeight: 200)
                      
                }
                    
                VStack {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 70)).foregroundColor(.white)
                    Spacer()
                        .frame(maxHeight : 20)
                        
                    Text(message)
                        .bold()
                        .foregroundColor(.white)
                }
                
                   
            }
            
        
    }
}

struct savePasswordAnimation_Previews: PreviewProvider {
    static var previews: some View {
        PopupAnimation(settings: SettingsViewModel(), message: "")
    }
}
