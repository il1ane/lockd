//
//  savePasswordAnimation.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 18/05/2021.
//

import SwiftUI

struct SavePasswordAnimation: View {

    var body: some View {
        
        ZStack {
            VStack {
            RoundedRectangle(cornerRadius: 20)
                
                .foregroundColor(.gray)
                .opacity(100)
                .frame(width: 200, height: 200)
            }
                
            Image(systemName: "checkmark.circle")
                .font(.system(size: 70)).foregroundColor(.white)
                .opacity(100)
        }
    }
}

struct savePasswordAnimation_Previews: PreviewProvider {
    static var previews: some View {
        SavePasswordAnimation()
    }
}
