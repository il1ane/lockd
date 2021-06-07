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
    @ObservedObject var passwordListViewModel:PasswordListViewModel
    @State private var password = ""
    @State private var showAlert = false
    @State private var revealPassword = false
    @Binding var isPresented: Bool
    @ObservedObject var settings:SettingsViewModel
    @State private var editingPassword = false
    @State private var editedPassword = ""
    @State private var editingUsername = false
    @State private var editedUsername = ""
    @Binding var title: String
    @Binding var username:String
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Mot de passe")) {
                    if !editingPassword {
                        HStack {
                            
                            HStack {
                                Spacer()
                                Text(revealPassword ? password : "****************************")
                                Spacer()
                            }
                            Spacer()
                            Button(action: { editingPassword.toggle()
                                editedPassword = password
                            }, label: {
                                Image(systemName: "pencil")
                                
                                
                            })
                            .foregroundColor(!revealPassword ? .gray : settings.colors[settings.accentColorIndex])
                            .buttonStyle(PlainButtonStyle())
                            .disabled(!revealPassword)
                            
                        }
                    } else {
                        HStack {
                            
                            CocoaTextField(password, text: $editedPassword)
                                .keyboardType(.asciiCapable)
                                .isFirstResponder(true)
                                .disableAutocorrection(true)
                            
                            Button(action: {
                                
                                editingPassword.toggle()
                                //showKeyboard doesn't change anything but Xcode stop complaining
                                //not always working
                                password = editedPassword
                                passwordListViewModel.updatePassword(key: key, newPassword: password)
                                
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
                
                Section(header: Text("Nom de compte")) {
                    
                    if !editingUsername {
                        
                        HStack {
                            Spacer()
                            Text(username)
                            Spacer()
                            Button(action: { editingUsername.toggle()
                                editedUsername = username
                            }, label: {
                                Image(systemName: "pencil")
                                
                            })
                        }
                    } else {
                        
                        HStack {
                            
                            TextField(username, text: $editedUsername)
                                .keyboardType(.asciiCapable)
                                .disableAutocorrection(true)
                            
                            Button(action: {
                                
                                editingUsername.toggle()
                                
                                username = editedUsername
                                password = passwordListViewModel.keychain.get(key)!
                                let newKey = passwordListViewModel.updateUsername(key: key, password: password, newUsername: username, title: title)
                                key = newKey
                                
                            }
                            , label: {
                                Image(systemName: "checkmark")
                            })
                            
                            .buttonStyle(PlainButtonStyle())
                            .foregroundColor(settings.colors[settings.accentColorIndex])
                        }
                    }
                    Button(action: { UIPasteboard.general.string = username }) {
                        
                        HStack {
                            Spacer()
                        Text("Copy")
                            Spacer()
                        }
                        
                    }.disabled(editingUsername)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(action: { showAlert.toggle() }, label: Text("Supprimer le mot de passe")).foregroundColor(.red)
                        Spacer()
                    }
                }
            }
            .actionSheet(isPresented: $showAlert,
                         content: {
                ActionSheet(title: Text("Supprimer le mot de passe"),
                            message: Text("Êtes vous certain de vouloir supprimer votre mot de passe? Cette action est irreversible."),
                            buttons: [.cancel(), .destructive(Text("Supprimer definitivement"),
                            action: { passwordListViewModel.keychain.delete(key); isPresented.toggle(); passwordListViewModel.getAllKeys()
                                passwordListViewModel.deletedPasswordHaptic()
                            })])
            })
            .navigationBarTitle(title)
            .navigationBarItems(leading:
                                    Button(action: { isPresented.toggle() }, label: Image(systemName: "xmark")),
                                trailing:
                                    Button(action: {
                                        
                                        password = passwordListViewModel.keychain.get(key)!
                                        revealPassword.toggle()
                                        passwordListViewModel.getAllUsernames()
                                        passwordListViewModel.getAllKeys()
                                        
                                    }, label: { revealPassword ?
                                        Image(systemName: "eye.slash") : Image(systemName: "eye")
                                    }).foregroundColor(settings.colors[settings.accentColorIndex]))
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(key: .constant("clérandom"), passwordListViewModel: PasswordListViewModel(), isPresented: .constant(true), settings: SettingsViewModel(), title: .constant("usernafame"), username: .constant("username"))
    }
}
