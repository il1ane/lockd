//
//  ClearPasswordsButton.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 08/07/2021.
//

import SwiftUI
import KeychainSwift

struct ClearPasswordsButton: View {
    
    @Binding var removePasswordAlert: Bool
    let keychain: KeychainSwift
    @ObservedObject var passwordViewModel: PasswordListViewModel
    
    var body: some View {
        
        Section() {
            Button(action: { removePasswordAlert.toggle() }, label: {
                Label(
                    title: { Text("Effacer tous les mots de passes").foregroundColor(.red)},
                    icon: { Image(systemName: "trash.fill").foregroundColor(.red)
                    }
                )
            }).buttonStyle(PlainButtonStyle())
        }
        .alert(isPresented: $removePasswordAlert,
               content: {
                
            Alert(title: Text("Effacer TOUS les mots de passes"),
                  message: Text("Vos mots de passes seront supprimés de manière définitive. Cette action est irreversible."),
                  primaryButton: .cancel(),
                  secondaryButton: .destructive(Text("TOUT supprimer"),
                                                action: {
                                                    keychain.clear()
                                                    passwordViewModel.addedPasswordHaptic()
                                                }))
        })
    }
}

struct ClearPasswordsButton_Previews: PreviewProvider {
    static var previews: some View {
        ClearPasswordsButton(removePasswordAlert: .constant(true), keychain: KeychainSwift(), passwordViewModel: PasswordListViewModel())
    }
}
