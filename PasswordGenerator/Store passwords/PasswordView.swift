//
//  PasswordView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 09/05/2021.
//

import SwiftUI
import SwiftUIX
import MobileCoreServices

struct PasswordView: View {
    
    @Binding var key: String
    @ObservedObject var viewModel:PasswordListViewModel
    @State private var password = ""
    @State private var showAlert = false
    @State private var revealPassword = false
    @Binding var isPresented: Bool
    @ObservedObject var settings:SettingsViewModel
    @State private var editingMode = false
    @State private var editedPassword = ""
    @Binding var username: String
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section {
                    if !editingMode {
                        HStack {
                            
                            HStack {
                                Spacer()
                                Text(revealPassword ? password : "****************************")
                                Spacer()
                            }
                            Spacer()
                            Button(action: { password = viewModel.keychain.get(key)!; revealPassword.toggle()
                            }, label: { editingMode ?
                                Image(systemName: "eye.slash") : Image(systemName: "eye")
                            }).buttonStyle(PlainButtonStyle()).foregroundColor(settings.colors[settings.accentColorIndex])
                        }
                    } else {
                        HStack {
                            
                            CocoaTextField(password, text: $editedPassword)
                                .keyboardType(.asciiCapable)
                                .isFirstResponder(true)
                                .disableAutocorrection(true)
                            
                            Button(action: {
                                
                                editingMode.toggle()
                                //showKeyboard doesn't change anything but Xcode stop complaining
                                //not always working
                                password = editedPassword
                                
                                
                            }, label: {
                                Image(systemName: "checkmark")
                            })
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(settings.colors[settings.accentColorIndex])
                        }
                    }
                    if revealPassword {
                        
                   
                        VStack {
                            Button(action: {
                                    UIPasteboard.general.string = password }, label: {
                                    
                                    HStack {
                                        Spacer()
                                        Text("Copier")
                                        Spacer()
                                    }
                                    
                                })
                        }
                    }
                }
               
                
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: { showAlert.toggle() }, label: Text("Supprimer le mot de passe")).foregroundColor(.red)
                        Spacer()
                    }
                }
                
                
                
            }        .actionSheet(isPresented: $showAlert, content: {
                ActionSheet(title: Text("Supprimer le mot de passe"), message: Text("Êtes vous certain de vouloir supprimer votre mot de passe? Cette action est irreversible."), buttons: [.cancel(), .destructive(Text("Supprimer definitivement"), action: { viewModel.keychain.delete(key); isPresented.toggle(); viewModel.getAllKeys() })])
            })
            .navigationBarItems(leading: Button(action: { isPresented.toggle() }, label: Image(systemName: "xmark")), trailing: Button(action: { editingMode.toggle()
                editedPassword = password
            }, label: {
                Image(systemName: "pencil")
            }).disabled(!revealPassword))
            .navigationBarTitle(username)
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(key: .constant("clérandom"), viewModel: PasswordListViewModel(), isPresented: .constant(true), settings: SettingsViewModel(), username: .constant("username"))
    }
}
