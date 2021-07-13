//
//  LoggingView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State private var scale: CGFloat = 1
    @ObservedObject var viewModel: SettingsViewModel
    @State var biometricType: SettingsViewModel.BiometricType
    @ObservedObject var passwordViewModel: PasswordListViewModel
    @ObservedObject var settingsViewModel: SettingsViewModel
    @State private var animate = false
    var body: some View {
       
        ZStack {
            
            Color.blue
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                    VStack {
                    Spacer()
                        
                        .frame(maxHeight : 30)
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 80))
                        .scaleEffect(scale)
                        .animateForever(using: .easeInOut(duration: 1), autoreverses: true, { scale = 0.95 })
                    }
                    .padding()
                
                    Spacer()
                
                    Button(action: {
                            if viewModel.biometricAuthentication() {
                            
                            passwordViewModel.getAllKeys() }
                        
                    },
                           label: {
                        Label(
                            title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("Entrer le mot mot de passe") },
                            icon: { Image(systemName: adaptativeImage(biometricType: biometricType)) }
                        )})
                      .foregroundColor(.white)
                      .padding()
                      .overlay(RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white, lineWidth: 1))
                       
                    Spacer()
                        .frame(maxHeight : 30)
                
            }
            .onAppear(perform: {
                biometricType = viewModel.biometricType()
                if settingsViewModel.unlockMethodIsActive == false {
                    settingsViewModel.isUnlocked = true
                    passwordViewModel.getAllKeys()
                    print("No biometric authentication")
                }
                
                if settingsViewModel.unlockMethodIsActive == true {
                    if settingsViewModel.biometricAuthentication() {
                        passwordViewModel.getAllKeys()
                    }
                    print("Biometric authentication")
                }
        })
            
        }.statusBar(hidden: true)
        .transition(.identity)
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
        AuthenticationView(viewModel: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.touch, passwordViewModel: PasswordListViewModel(), settingsViewModel: SettingsViewModel())
    }
}
