//
//  OnboardingView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 26/05/2021.
//

import SwiftUI

struct OnboardingView: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    @Binding var isPresented: Bool
    @State var biometricType: SettingsViewModel.BiometricType
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack {
            Spacer()
            
            Text("Bienvenue sur lockd")
                .font(.title)
                .bold()
            
            Spacer()
            
            VStack(alignment: .leading) {
                
                OnboardingCell(image: "key.fill",
                               text: "Génerez vos mots de passe sécurisés sur-mesure",
                               title: "Mots de passe")
                    .padding()
                
                OnboardingCell(image: "lock.square",
                               text: "Stockez vos mots de passe dans votre coffre et retrouvez les rapidement",
                               title: "Coffre fort")
                    .padding()
                
                OnboardingCell(image: adaptativeImage(biometricType: biometricType),
                               text: adaptativeMessage(biometricType: biometricType),
                               title: "Sécurisé")
                    .padding()
                
            }
            .padding()
            
            Spacer()
            
            Button(action: { isPresented = false },
                   label: {
                    
                    HStack {
                        Spacer().frame(maxWidth: 100)
                        Text("Continuer").foregroundColor(.white)
                        Spacer().frame(maxWidth: 100)
                    }})
                .padding()
                .background(settingsViewModel.colors[settingsViewModel.accentColorIndex])
                .cornerRadius(10)
            
            Spacer()
            
        }
        .environment(\.colorScheme, colorScheme)
        .font(.body)
        .onAppear(perform: {
            biometricType = settingsViewModel.biometricType()
        })
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(settingsViewModel: SettingsViewModel(), isPresented: .constant(true), biometricType: .touch)
    }
}
