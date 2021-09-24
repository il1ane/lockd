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
    
    var body: some View {
        
        if !settings.isHiddenInAppSwitcher {
            ZStack {
                
                Form {
                    
                    Section(header: Text("Mot de passe")) {
                        
                        if #available(iOS 15, *) {
                        
                        PasswordSection(password: $password,
                                        revealPassword: $revealPassword,
                                        key: key,
                                        clipboardSaveAnimation: $clipboardSaveAnimation,
                                        passwordListViewModel: passwordListViewModel,
                                        passwordGeneratorViewModel: passwordGeneratorViewModel,
                                        settings: settings,
                                        isEditingPassword: $editingPassword,
                                        editedPassword: $editedPassword)
                                .privacySensitive(settings.privacyMode ? true : false)
                            
                        } else {
                            PasswordSection(password: $password,
                                            revealPassword: $revealPassword,
                                            key: key,
                                            clipboardSaveAnimation: $clipboardSaveAnimation,
                                            passwordListViewModel: passwordListViewModel,
                                            passwordGeneratorViewModel: passwordGeneratorViewModel,
                                            settings: settings,
                                            isEditingPassword: $editingPassword,
                                            editedPassword: $editedPassword)
                        }
                        
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
                                        clipboardSaveAnimation: $clipboardSaveAnimation,
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
                                        .foregroundColor(settings.colors[settings.accentColorIndex]))
                
                
                if clipboardSaveAnimation {
                    
                    PopupAnimation(settings: settings, message: settings.ephemeralClipboard ? "Copié! (60s)" : "Copié!")
                        .onAppear(perform: { clipBoardAnimationDisapear() })
                        .animation(.easeInOut(duration: 0.1))
                    
                }
                
            }
         
            
            .onAppear(perform: { if username.isEmpty { showUsernameSection = false }})
            
            
            
        }
    }
}

extension PasswordView {
    
    func getPassword() {
        
        password = passwordListViewModel.keychain.get(key)!
        
        print(password)
        revealPassword.toggle()
        passwordListViewModel.getAllKeys()
        passwordListViewModel.getPasswordHaptic()
        
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
        PasswordView(key: "", passwordListViewModel: PasswordListViewModel(), passwordGeneratorViewModel: PasswordGeneratorViewModel(), settings: SettingsViewModel(), title: "", username: "")
    }
}

