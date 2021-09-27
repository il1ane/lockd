//
//  SecurityInfoViewswift.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 25/09/2021.
//

import SwiftUI

struct SecurityInfoView: View {
    
    let entropy: Double
    let characterCount: Double
    let combinaisons: Double
    @State var offset = CGFloat()
    let gradient = Gradient(stops: [
        .init(color: .red, location: 0.07),
        .init(color: .orange, location: 0.15),
        .init(color: .yellow, location: 0.28),
        .init(color: .green, location: 0.36),
        .init(color: .blue, location: 1)
    ])
    
    var body: some View {
        
        VStack {
          
            HStack {

               Image(systemName: "shield.fill")
                    .font(.largeTitle)
                    .foregroundColor(entropyColor(entropy: entropy))
                    .overlay {
                        Image(systemName: "key.fill")
                            .foregroundColor(.white)
                            .font(.body)
                    }
                   
                    
                
                VStack(alignment: .leading) {
                    Text(entropyText(entropy:entropy)).bold()
                    HStack {
                        Text("Entropie:")
                        Text("\(Int(entropy)) bits")
                    }
                    
                }
            }
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing))
                .frame(width: 188 * 2, height: 10)
            
                .overlay(
                    
                    Circle()
                            .frame(width: 20, height: 20)
                            .offset(x: -188 + entropy * 2, y: 0)
                            .foregroundColor(.white)
                            .opacity(0.9)
                            .shadow(radius: 1))
                
                
            
            Divider()
            
            VStack {
                Text("Nombre de combinaisons possibles")
                    .bold()
                Text(characterCount > 5 ? "\(combinaisons.scientificFormatted)" : "\(String(format: "%.2f", combinaisons))")
               //String(format: "%.2f", number)
                
            }.padding()
        }
        .padding(10)
        
    }
}


extension View {
    
//    func entropyOffset(entropy: Double) -> CGFloat {
//
//    case 128.0...200:
//        let generator = UIImpactFeedbackGenerator(style: .rigid)
//        print("haptic feedback intensity : 1")
//        generator.impactOccurred(intensity: 1)
//    case 60.0...128:
//        let generator = UIImpactFeedbackGenerator(style: .rigid)
//        print("haptic feedback intensity : 0.8")
//        generator.impactOccurred(intensity: 0.8)
//    case 36.0...60:
//        let generator = UIImpactFeedbackGenerator(style: .rigid)
//        print("haptic feedback intensity : 0.6")
//        generator.impactOccurred(intensity: 0.6)
//    case 28.0...36:
//        let generator = UIImpactFeedbackGenerator(style: .rigid)
//        print("haptic feedback intensity : 0.4")
//        generator.impactOccurred(intensity: 0.4)
//    default:
//        let generator = UIImpactFeedbackGenerator(style: .rigid)
//        print("haptic feedback intensity : 0.2")
//        generator.impactOccurred(intensity: 0.2)
//
//        if entropy > 94 {
//            return entropy / 2
//        } else {
//            return -entropy / 2
//        }
        
//    }
}

    
struct SecurityInfoViewswift_Previews: PreviewProvider {
    static var previews: some View {
        SecurityInfoView(entropy: 94, characterCount: 20, combinaisons: 100)
    }
}

extension Formatter {
    static let scientific: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.###E+0"
        formatter.exponentSymbol = "e"
        return formatter
    }()
}

extension Numeric {
    var scientificFormatted: String {
        return Formatter.scientific.string(for: self) ?? ""
    }
}
