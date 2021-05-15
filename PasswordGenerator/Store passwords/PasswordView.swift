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
    @State private var revealPassword = false
    @Binding var isPresented: Bool
    
    var body: some View {
        
        NavigationView {
            Form {
                
                HStack {
                    HStack {
                        Spacer()
                        Text(revealPassword ? password : "****************************")
                        Spacer()
                    }
                    Spacer()
                    Button(action: { password = viewModel.keychain.get(key)!; revealPassword.toggle()
                    }, label: {
                        Image(systemName: "eye")
                    }).buttonStyle(PlainButtonStyle()).foregroundColor(.green)
                }
               
                HStack {
                    Spacer()
                    Button(action: { showAlert.toggle() }, label: Text("Supprimer le mot de passe"))
                    Spacer()
                }
                
            }        .actionSheet(isPresented: $showAlert, content: {
                ActionSheet(title: Text("Supprimer le mot de passe"), message: Text("Êtes vous certain de vouloir supprimer votre mot de passe? Cette action est irreversible."), buttons: [.cancel(), .destructive(Text("Supprimer definitivement"), action: { viewModel.keychain.delete(key); isPresented.toggle(); viewModel.refreshKeys() })])
            })
            .navigationBarItems(leading: Button(action: { isPresented.toggle() }, label: Image(systemName: "xmark")), trailing: Button(action: {  }, label: {
                Image(systemName: "pencil")
            }))
            .navigationBarTitle(key)
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(key: .constant("clérandom"), viewModel: PasswordListViewModel(), isPresented: .constant(true))
    }
}
