//
//  SavePasswordView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 07/05/2021.
//

import SwiftUI
import SwiftUIX

struct SavePasswordView: View {
    
    @Binding var password: String
    @Binding var isPresented: Bool
    @ObservedObject var editedPassword = TextBindingManager(limit: 30)
    @State private var passwordTitle = ""
    @State private var username = ""
    @State private var isEditingPassword = false
    @State private var showKeyboard = false
    @State private var passwordLenght = ""
    let keyboard = Keyboard()
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                Form {
                    Section(header: Text("Modifier votre mot de passe"), footer: passwordLenght.isEmpty ? Text("Le mot de passe ne peut pas être vide").foregroundColor(.red) : nil) {
                        HStack {
                            Spacer()
                            if !isEditingPassword {
                                Text(editedPassword.text)
                                    .foregroundColor(.gray).font(editedPassword.characterLimit > 25 ? .system(size: 15) : .body)
                                   
                            } else {
                                
                                CocoaTextField(password, text: $editedPassword.text)
                                .keyboardType(.asciiCapable)
                                .isFirstResponder(true)
                                .disableAutocorrection(true)
                            }
                            Spacer()
                            
                            if !isEditingPassword {
                                
                                Button(action: {
                                    withAnimation {
                                    isEditingPassword.toggle()
                                    showKeyboard = keyboard.isShowing
                                    
                                    }
                                    
                                }, label: {
                                    Text("Edit")
                                })
                                .buttonStyle(PlainButtonStyle())
                                .foregroundColor(.green)
                            }
                            else {
                                Button(action: {
                                    withAnimation(.default) {
                                    isEditingPassword.toggle()
                                    //showKeyboard doesn't change anything but Xcode stop complaining
                                    //not always working
                                    showKeyboard = keyboard.isShowing
                                        passwordLenght = editedPassword.text
                                    }
                                    
                                }, label: {
                                    Image(systemName: "checkmark")
                                })
                                .buttonStyle(PlainButtonStyle())
                                .foregroundColor(.green)
                            }
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
        }.onAppear(perform: {
            editedPassword.text = password
            passwordLenght = password
        })
    }
}

struct SavePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        SavePasswordView(password: .constant("MotDePasseExtremementCompliqué"), isPresented: .constant(true)).accentColor(.green)
    }
}
