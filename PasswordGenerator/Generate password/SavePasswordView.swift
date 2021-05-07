//
//  SavePasswordView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 07/05/2021.
//

import SwiftUI

struct SavePasswordView: View {
    
    @Binding var password: String
    @Binding var isPresented: Bool
    @State private var passwordTitle = ""
    @State private var username = ""
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Form {
                    Section(header: Text("Modifier votre mot de passe")) {
                        HStack {
                            Spacer()
                            Text(password)
                                .foregroundColor(.gray)
                            Spacer()
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Edit")
                            })
                            
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(.green)
                        }
                    }
                    
                    Section(header: Text("Intitulé")) {
                        TextField("ex: Facebook", text: $passwordTitle)
                    }
                    
                    Section(header: Text("Nom de compte (optionel)")) {
                        TextField("ex: momail@icloud.com", text: $username)
                    }
                    
                }.navigationBarTitle("Enregistrement")
                .navigationBarItems(leading: Button(action: {
                    
                    isPresented.toggle()
                    
                }, label: {
                    Image(systemName: "xmark")
                }), trailing: Button(action: {
                    
                    isPresented.toggle()
                    //add code to save to keychain
                }, label: {
                    Image(systemName: "tray.and.arrow.down")
                }))
            }
        }
    }
}

struct SavePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SavePasswordView(password: .constant("MotDePasseExtremementCompliqué"), isPresented: .constant(true))
    }
}
