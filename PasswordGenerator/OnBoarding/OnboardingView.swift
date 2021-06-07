//
//  OnboardingView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 26/05/2021.
//

import SwiftUI

struct OnboardingView: View {
    
    @ObservedObject var settings: SettingsViewModel
    @Binding var isPresented: Bool
    @State var biometricType: SettingsViewModel.BiometricType
    
    var body: some View {
        VStack {
            Spacer()
            Text("Bienvenue sur lockd").font(.title).bold()
            Spacer()
            VStack(alignment: .leading) {
                
                OnboardingCell(image: "key.fill", color: settings.colors[settings.accentColorIndex], text: "Génerez vos mots de passe sécurisés sur-mesure", title: "Mots de passe").padding()
                
                OnboardingCell(image: "lock.square", color: settings.colors[settings.accentColorIndex], text: "Stockez vos mots de passe dans votre coffre et retrouvez les rapidement", title: "Coffre fort").padding()
                
                OnboardingCell(image: biometricType == .face ? "faceid" : biometricType == .touch ? "touchid" : "key", color: settings.colors[settings.accentColorIndex], text: biometricType == .face ? "Protégez vos mots de passes avec Face ID" : biometricType == .touch ? "Protégez vos mots de passes avec Touch ID" : "Protégez vos mots de passes avec votre code de verouillage d'iPhone", title: "Sécurisé").padding()
                
//                Label(
//                    title: { biometricType == .face ? Text("Déverouiller avec Face ID") : biometricType == .touch ? Text("Déverouiller avec Touch ID") : Text("Entrer le mot mot de passe") },
//                    icon: { biometricType == .face ? Image(systemName: "faceid") : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "key.fill") }
//                )
                
            }.padding()
            Spacer()
            Button(action: { isPresented = false },
                   label: {
                    
                    HStack {
                        Spacer().frame(maxWidth: 100)
                        Text("Continuer").foregroundColor(.white)
                        Spacer().frame(maxWidth: 100)
                    }})
                .padding()
                .background(settings.colors[settings.accentColorIndex])
                .cornerRadius(10)
            Spacer()
        }.font(.body)
        .onAppear(perform: {
            //set biometric type for device
            biometricType = settings.biometricType()
        })
        
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(settings: SettingsViewModel(), isPresented: .constant(true), biometricType: .touch)
    }
}
