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
                Text(entropyText(entropy: entropy))
                    .foregroundColor(.white)
            }
            .padding(5)
            .background(entropyColor(entropy: entropy))
            .cornerRadius(7)
            .animation(animate ? .easeInOut : nil)
            .transition(.identity)
            .onChange(of: entropy, perform: { value in
                animate = true
            })
    }
}

extension View {
    
    func entropyText(entropy: Double) -> String {
        
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
        PasswordStrenghtView(entropy: 200)
    }
}
