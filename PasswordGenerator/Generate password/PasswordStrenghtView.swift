//
//  PasswordStrenghtView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 09/06/2021.
//

import SwiftUI

struct PasswordStrenghtView: View {
    
    let entropy:Double
    @State private var animate = false
    
    var body: some View {
        
            HStack {
                Text(entropy > 128.0 ? "Très robuste" : entropy > 60.0 ? "Robuste" : entropy > 36.0 ? "Moyen" : entropy > 28.0 ? "Faible" : "Très faible")
                    .foregroundColor(.white)
                
            }.padding(5).background(entropy > 128.0 ? .blue : entropy > 60.0 ? .green: entropy > 36.0 ? .yellow : entropy > 28.0 ? .orange : .red)
            .cornerRadius(7)
            .animation(animate ? .easeInOut : nil)
            .transition(.identity)
            .onChange(of: entropy, perform: { value in
                animate = true
            })
        
        
            
    }
}

struct PasswordStrenghtView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordStrenghtView(entropy: 200)
    }
}
