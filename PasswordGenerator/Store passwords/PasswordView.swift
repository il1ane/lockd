//
//  PasswordView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 09/05/2021.
//

import SwiftUI

struct PasswordView: View {
    
    @Binding var key: String
    @ObservedObject var viewModel:PasswordListViewModel
    @State private var password = ""
    @State private var showAlert = false
    @Binding var isPresented: Bool
    
    var body: some View {
        
        Form {
            Text(key)
            Text(password)
            Button(action: { password = viewModel.keychain.get(key)!
            }, label: {
                Text("Get password")
            })
            Button(action: { showAlert.toggle() }, label: Text("Delete key"))
            
        }        .actionSheet(isPresented: $showAlert, content: {
            ActionSheet(title: Text("Supprimer le mot de passe"), message: Text("Êtes vous certain de vouloir supprimer votre mot de passe? Cet action est irreversible"), buttons: [.cancel(), .destructive(Text("Supprimer definitivement"), action: { viewModel.keychain.delete(key); isPresented.toggle(); viewModel.refreshKeys() })])
        })
        .navigationBarTitle(key)
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(key: .constant("clérandom"), viewModel: PasswordListViewModel(), isPresented: .constant(true))
    }
}
