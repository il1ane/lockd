//
//  UnlockMethodToggle.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 08/07/2021.
//

import SwiftUI

struct UnlockMethodToggle: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    var biometricType: SettingsViewModel.BiometricType
    
    var body: some View {
        Toggle(isOn: $settingsViewModel.faceIdToggle,
               label: {
                Label(title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("Déverouiller avec votre mot de passe") },
                      icon: { biometricType == .face ?
                    Image(systemName: "faceid")                    : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "key.fill") }
                )
               })
            .toggleStyle(SwitchToggleStyle(tint: settingsViewModel.colors[settingsViewModel.accentColorIndex]))
   
            .onChange(of: settingsViewModel.faceIdToggle, perform: { _ in
                
                if settingsViewModel.faceIdToggle {
                    settingsViewModel.addBiometricAuthentication()
                    print("Waiting for auth")
                }
                
                if !settingsViewModel.faceIdToggle {
                    settingsViewModel.turnOffBiometricAuthentication()
                }
            })
    }
}

struct UnlockMethodToggle_Previews: PreviewProvider {
    static var previews: some View {
        UnlockMethodToggle(settingsViewModel: SettingsViewModel(), biometricType: SettingsViewModel.BiometricType.face)
    }
}

struct ColoredToggleStyle: ToggleStyle {
    var text: String
    var icon: String
    var onColor = LinearGradient(colors: [.blue, .purple], startPoint: .trailing, endPoint: .leading)
    var offColor = LinearGradient(colors: [.blue, .purple], startPoint: .bottom, endPoint: .top)
    var thumbColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            Label(text, systemImage: icon)
            Spacer()
            Button(action: { configuration.isOn.toggle() } )
            {
                RoundedRectangle(cornerRadius: 16, style: .circular)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 29)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .shadow(radius: 1, x: 0, y: 1)
                            .padding(1.5)
                            .offset(x: configuration.isOn ? 10 : -10))
                    .animation(Animation.easeInOut(duration: 0.1))
            }
        }
        .padding(.horizontal)
    }
}
    

