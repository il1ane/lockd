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
    @State var key: String
    @ObservedObject var passwordListViewModel:PasswordListViewModel
    @ObservedObject var passwordGeneratorViewModel:PasswordGeneratorViewModel
    @ObservedObject var settings:SettingsViewModel
    @State private var showAlert = false
    @State var title: String
    @State var username:String
    @State private var clipboardSaveAnimation = false
    @State private var showUsernameSection = true
    @State private var revealPassword = false
    @State private var password = ""
    @State private var editingUsername = false
    @State private var editedUsername = ""
    @State private var editingPassword = false
    @State private var editedPassword = ""
    @State private var isLocked = true
    @State private var savedChangesAnimation = false
    
    var body: some View {
        
        if !settings.isHiddenInAppSwitcher {
            ZStack {
                
                Form {
                    
                    Section(header: Text("Mot de passe")) {
                        
                            PasswordSection(password: $password,
                                            revealPassword: $revealPassword,
                                            key: key,
                                            clipboardSaveAnimation: $clipboardSaveAnimation,
                                            passwordListViewModel: passwordListViewModel,
                                            passwordGeneratorViewModel: passwordGeneratorViewModel,
                                            settings: settings,
                                            isEditingPassword: $editingPassword, savedChangesAnimation: $savedChangesAnimation,
                                            editedPassword: $editedPassword)
                        
                    }
                    
                    Section(header: Text("Nom de compte")) {
                        
                        UsernameSection(showUsernameSection: $showUsernameSection,
                                        editingUsername: $editingUsername,
                                        editedPassword: $editedPassword,
                                        editedUsername: $editedUsername,
                                        username: $username,
                                        key: $key,
                                        password: $password,
                                        title: $title,
                                        clipboardSaveAnimation: $clipboardSaveAnimation, savedChangesAnimation: $savedChangesAnimation,
                                        passwordListViewModel: passwordListViewModel,
                                        passwordGeneratorViewModel: passwordGeneratorViewModel,
                                        settings: settings)
                        
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
                                buttons: [.cancel(),
                                          .destructive(Text("Supprimer definitivement"),
                                                       action: {
                        
                        passwordListViewModel.keychain.delete(key)
                        //isPresented.toggle()
                        passwordListViewModel.getAllKeys()
                        passwordListViewModel.deletedPasswordHaptic()
                        
                    }
                                                      )])
                })
                
                .navigationBarTitle(title)
                .navigationBarItems(trailing:
                                        
                    Button(action: {
                        
                        getPassword()
                        
                    }, label: { revealPassword ?
                        Image(systemName: "eye.slash") : Image(systemName: "eye")
                        
                    })
                                            .padding(5)
                                        .foregroundColor(settings.colors[settings.accentColorIndex])
               
                   
                )
                
            }
            .popup(isPresented: $clipboardSaveAnimation, type: .toast, position: .top, autohideIn: 2) {
                VStack(alignment: .center) {
                    Spacer()
                        .frame(height: UIScreen.main.bounds.height / 22)
                    Label(settings.ephemeralClipboard ? "Copié (60sec)" : "Copié", systemImage: settings.ephemeralClipboard ? "timer" : "checkmark.circle.fill")
                    .padding(14)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(30)
                }
            }
            
            .popup(isPresented: $savedChangesAnimation, type: .toast, position: .top, autohideIn: 2) {
                VStack(alignment: .center) {
                    Spacer()
                        .frame(height: UIScreen.main.bounds.height / 22)
                    Label("Modifications enregistrées", systemImage: "checkmark.circle.fill")
                    .padding(14)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(30)
                }
            }
         
            .onAppear(perform: { if username.isEmpty { showUsernameSection = false }})

        }
    }
}

extension PasswordView {
    
    func getPassword() {
        
        password = passwordListViewModel.keychain.get(key)!
        revealPassword.toggle()
        passwordListViewModel.getAllKeys()
        passwordListViewModel.getPasswordHaptic()
        
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(key: "", passwordListViewModel: PasswordListViewModel(), passwordGeneratorViewModel: PasswordGeneratorViewModel(), settings: SettingsViewModel(), title: "", username: "")
    }
}

