//
//  OnboardingCell.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 26/05/2021.
//

import SwiftUI

struct OnboardingCell: View {
    
    let image:String
    let color:Color
    let text:String
    let title:String
    
    var body: some View {
        
        HStack {
            Image(systemName: image)
                .frame(minWidth: 50, maxWidth: 60, minHeight: 50, maxHeight: 60)
                .font(.largeTitle)
                .foregroundColor(.white)
                .background(color)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                
                Text(title).bold()
                Spacer().frame(height: 5)
                Text(text)
                    .font(.body)
                    .foregroundColor(.gray)
            }.padding()
        }
    }
}

struct OnboardingCell_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCell(image: "lock.fill", color: .blue, text: "Ajsqdfoifjazkfafafniaf aberaiunrafarv avunrrah vahbva.", title: "Sécurisé")
    }
}
