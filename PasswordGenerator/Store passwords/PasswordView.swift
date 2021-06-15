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
    
    @Environment(\.presentationMode) var presentation
    @Binding var key: String
    @ObservedObject var passwordListViewModel:PasswordListViewModel
    @ObservedObject var passwordGeneratorViewModel:PasswordGeneratorViewModel
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
    @State private var clipboardSaveAnimation = false
    @State private var showUsernameSection = true
    
    var body: some View {
        
        ZStack {
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
                                CocoaTextField("password", text: $editedPassword)
                                    .keyboardType(.asciiCapable)
                                    .isFirstResponder(true)
                                    .disableAutocorrection(true)
                                
                                Button(action: {
                                    editingPassword.toggle()
                                    password = editedPassword
                                    passwordListViewModel.updatePassword(key: key, newPassword: password)
                                    passwordListViewModel.addedPasswordHaptic()
                                },     label: {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(!editedPassword.isEmpty ? .green : .blue)
                                })
                                .disabled(editedPassword.isEmpty)
                                .buttonStyle(PlainButtonStyle())
                                .foregroundColor(settings.colors[settings.accentColorIndex])
                            }
                        }
                        
                        Button(action: {
                            UIPasteboard.general.string = password
                            passwordGeneratorViewModel.copyPasswordHaptic()
                            clipboardSaveAnimation = true
                            }, label: {
                            
                            HStack {
                                Spacer()
                                Text("Copier")
                                Spacer()
                            }
                                
                        })
                        .disabled(revealPassword ? false : true)
                    }
                    
                    if showUsernameSection {
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
                                    CocoaTextField("Username", text: $editedUsername)
                                        .keyboardType(.asciiCapable)
                                        .isFirstResponder(true)
                                        .disableAutocorrection(true)
                                    
                                    Button(action: {
                                        editingUsername.toggle()
                                        username = editedUsername
                                        password = passwordListViewModel.keychain.get(key)!
                                        let newKey = passwordListViewModel.updateUsername(key: key, password: password, newUsername: username, title: title)
                                        key = newKey
                                        passwordListViewModel.addedPasswordHaptic()
                                        
                                    }
                                    , label: {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(!editedPassword.isEmpty ? .green : .blue)

                                    })
                                    .buttonStyle(PlainButtonStyle())
                                    .foregroundColor(settings.colors[settings.accentColorIndex])
                                }
                            }
                            Button(action: { UIPasteboard.general.string = username
                                passwordGeneratorViewModel.copyPasswordHaptic()
                                clipboardSaveAnimation = true
                            }) {
                                
                                HStack {
                                    Spacer()
                                    Text("Copier")
                                    Spacer()
                                }
                            }
                            .disabled(editingUsername)
                        }
                    } else {
                        HStack {
                            Spacer()
                            Button(action : { showUsernameSection = true }, label: Text("Ajouter un nom de compte"))
                            Spacer()
                        }
                    }
                    
                    Section {
                        
                        HStack {
                            Spacer()
                            Button(action: { showAlert.toggle() }, label:
                                    Text("Supprimer le mot de passe")
                                    .foregroundColor(.red))
                            Spacer()
                        }
                    }
                }
                .actionSheet(isPresented: $showAlert,
                              content: {
                                ActionSheet(title: Text("Supprimer le mot de passe"),
                                            message: Text("Êtes vous certain de vouloir supprimer votre mot de passe? Cette action est irreversible."),
                                            buttons: [.cancel(), .destructive(Text("Supprimer definitivement"),
                                            action: {
                                            passwordListViewModel.keychain.delete(key);
                                            isPresented.toggle();
                                            passwordListViewModel.getAllKeys()
                                            passwordListViewModel.deletedPasswordHaptic()
                                            })])
                              })
                .navigationBarTitle(title)
                .navigationBarItems(leading:
                                        Button(action: { isPresented.toggle() }, label: Image(systemName: "xmark"))
                                        .padding(5),
                                    
                                    trailing:
                                        Button(action: {
                                            
                                            password = passwordListViewModel.keychain.get(key)!
                                            revealPassword.toggle()
                                            passwordListViewModel.getAllKeys()
                                            passwordListViewModel.deletedPasswordHaptic()
                                            
                                        }, label: { revealPassword ?
                                            Image(systemName: "eye.slash") : Image(systemName: "eye")
                                            
                                        })
                                        .padding(5)
                                        .foregroundColor(settings.colors[settings.accentColorIndex]))
                
                
            }
            if clipboardSaveAnimation {
                PopupAnimation(settings: settings, message: "Copié!")
                    .onAppear(perform: { clipBoardAnimationDisapear() })
                    .animation(.easeInOut(duration: 0.1))
            }
        }.onAppear(perform: { if username.isEmpty { showUsernameSection = false }})
    }
    
    func clipBoardAnimationDisapear() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            clipboardSaveAnimation = false
            print("Show animation")
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(key: .constant("clérandom"), passwordListViewModel: PasswordListViewModel(), passwordGeneratorViewModel: PasswordGeneratorViewModel(), isPresented: .constant(true), settings: SettingsViewModel(), title: .constant("usernafame"), username: .constant(""))
    }
}
