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
                    
                VStack {
                    Image(systemName: "checkmark.circle")
                        .font(.system(size: 70)).foregroundColor(.white)
                    Spacer()
                        .frame(maxHeight : 20)
                        
                    Text("Ajouté au coffre")
                        .bold()
                        .foregroundColor(.white)
                }
                
                   
            }
            
        
    }
}

struct savePasswordAnimation_Previews: PreviewProvider {
    static var previews: some View {
        SavePasswordAnimation(settings: SettingsViewModel())
    }
}
