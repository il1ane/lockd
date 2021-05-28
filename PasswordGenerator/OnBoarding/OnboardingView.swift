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
    
    var body: some View {
        VStack {
            Spacer()
            Text("Bienvenue").font(.title).bold()
            Spacer()
            VStack(alignment: .leading) {
                
                OnboardingCell(image: "die.face.5.fill", color: settings.colors[settings.accentColorIndex], text: "Génerez aléatoirement vos mots de passe sur-mesure", title: "Mots de passe aléatoires").padding()
                
                OnboardingCell(image: "lock.fill", color: settings.colors[settings.accentColorIndex], text: "Stockez vos mots de passe de manière sécurisé", title: "Sécurisé").padding()
                
                OnboardingCell(image: "paintpalette.fill", color: settings.colors[settings.accentColorIndex], text: "Modifiez les couleurs de l'application", title: "Personnalisable").padding()
                
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
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(settings: SettingsViewModel(), isPresented: .constant(true))
    }
}
