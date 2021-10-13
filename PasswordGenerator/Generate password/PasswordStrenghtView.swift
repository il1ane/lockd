//
//  PasswordStrenghtView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 09/06/2021.
//

import SwiftUI

struct PasswordStrenghtView: View {
    
    let entropy:Double
    let characterCount: Double
    @State private var animate = false
    
    var body: some View {
        
        
        VStack {
            HStack {
                
                Image(systemName: "shield.fill")
                            .foregroundColor(entropyColor(entropy: entropy))
                            .font(.largeTitle)
            
                    .overlay(
                             Text("\(Int(entropy))")
                                 .foregroundColor(.white)
                                .font(.footnote)
                                .bold()
                             
                    )
               
                
            }
        }
    }
}

extension View {
    
    func entropyText(entropy: Double) -> LocalizedStringKey {
        
        switch entropy {
        case 128.0...200:
            return "Très robuste"
        case 60.0...128:
            return "Robuste"
        case 36.0...60:
            return "Moyen"
        case 28.0...36:
            return "Faible"
        default:
            return "Très faible"
        }
    }
    
    func entropyColor(entropy: Double) -> Color {
        
        switch entropy {
        case 128.0...200:
            return .blue
        case 60.0...128:
            return .green
        case 36.0...60:
            return .yellow
        case 28.0...36:
            return .orange
        default:
            return .red
        }
    }
}

struct PasswordStrenghtView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordStrenghtView(entropy: 200, characterCount: 20)
    }
}
