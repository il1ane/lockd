//
//  SecurityInfoViewswift.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 25/09/2021.
//

import SwiftUI

struct StrenghtMeterView: View {
    
    @State var offset = CGFloat()
    @ObservedObject var viewModel = PasswordListViewModel()
    let entropy: Double
    let characterCount: Double
    let gradient = Gradient(stops: [
        .init(color: .red, location: 0.07),
        .init(color: .orange, location: 0.15),
        .init(color: .yellow, location: 0.28),
        .init(color: .green, location: 0.36),
        .init(color: .blue, location: 1)
    ])
    let combinaisons: Double
    let ratio:CGFloat = 250
    let lenght: Int
    let animation:Double = 1.4
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .center) {
                
                Spacer().frame(height: 15)
                
                HStack {
        
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing))
                        .frame(width: 190 * UIScreen.main.bounds.width / ratio, height: 17)
                        .overlay(
                            VStack(alignment: .center) {
                                Rectangle()
                                    .fill(LinearGradient(gradient: gradient, startPoint: .leading, endPoint: .trailing))
                                    .frame(width: 190 * UIScreen.main.bounds.width / ratio, height: 80)
                            }
                            
                                .mask(
                                    VStack(alignment: .center) {
                                        Image(systemName: "triangle.fill")
                                            .rotationEffect(Angle(degrees: 180))
                                            .font(.system(size: 10))
                                    }
                                        .offset(x: calculateOffset(entropy: entropy), y: -20)
                                        .foregroundColor(.blue)
                                        .shadow(radius: 1)
                                        .animation(.easeIn(duration: 0.55))
                                        .transition(.opacity)))
                    
                    Spacer()
                    
                }
            }
            
            VStack {
                HStack {
                    Text("Nombre de combinaisons possibles")
                    Spacer()
                    Text(characterCount > 6 ? "\(combinaisons.scientificFormatted)" : "\(combinaisons.largeNumberFormat)").transition(.opacity)
                }
                
                
                Divider().padding()
                
                HStack {
                    Text("Entropie")
                    Spacer()
                    Text("\(Int(entropy)) bits")
                        .transition(.opacity)
                }
                
                Divider().padding()
                
                HStack {
                    Text("Nombre de caractères")
                    Spacer()
                    Text("\(lenght)")
                        .transition(.opacity)
                }
            }
            .padding()
            
        }
    }
}



extension StrenghtMeterView {
    
    func calculateOffset(entropy: Double) -> CGFloat {
        
        switch(entropy) {
        case 0...4:
            return ((-190 * UIScreen.main.bounds.width / ratio) / 2) + 5 * UIScreen.main.bounds.width / ratio
        case 187...189:
            return ((-190 * UIScreen.main.bounds.width / ratio) / 2) + 186 * UIScreen.main.bounds.width / ratio
        default:
            return ((-190 * UIScreen.main.bounds.width / ratio) / 2) + entropy * UIScreen.main.bounds.width / ratio
        }
    }
}


struct SecurityInfoViewswift_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            StrenghtMeterView(entropy: 0, characterCount: 20, combinaisons: 100, lenght: 12)
                .preferredColorScheme(.dark)
        }
    }
}

extension Formatter {
    
    static let largeNumber: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
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
    
    var largeNumberFormat: String {
        return Formatter.largeNumber.string(for: self) ?? ""
    }
}
