//
//  LoggingView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import SwiftUI

struct LoggingView: View {
    
    @State private var scale: CGFloat = 1
    @ObservedObject var viewModel: SettingsViewModel
    var body: some View {
       
            VStack {
                VStack {
                Spacer().frame(maxHeight : 120)
                Text("🥳")
                    .font(.system(size: 100))
                    .scaleEffect(scale)
                    .animateForever(using: .easeInOut(duration: 1), autoreverses: true, { scale = 0.95 })
                Text("Ravis de vous revoir!").bold()
                }.padding()
                Spacer()
                Button(action: { viewModel.authenticate() }, label: {
                    Label(
                        title: { Text("Déverouiller avec Face ID") },
                        icon: { Image(systemName: "faceid") }
)
                }).foregroundColor(.white).padding().background(Color.green).cornerRadius(15)
                Spacer().frame(maxHeight : 30)
            
        }
    }
}

extension View {
    func animateForever(using animation: Animation = Animation.easeInOut(duration: 1), autoreverses: Bool = false, _ action: @escaping () -> Void) -> some View {
        let repeated = animation.repeatForever(autoreverses: autoreverses)

        return onAppear {
            withAnimation(repeated) {
                action()
            }
        }
    }
}

struct LoggingView_Previews: PreviewProvider {
    static var previews: some View {
        LoggingView(viewModel: SettingsViewModel())
    }
}
