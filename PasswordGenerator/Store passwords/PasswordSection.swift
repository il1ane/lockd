//
//  PasswordSection.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 07/07/2021.
//

import SwiftUI
import SwiftUIX

//Password section from PasswordView

struct PasswordSection: View {
    
    @Binding var password: String
    @Binding var revealPassword:Bool
    @Binding var key: String
    @Binding var clipboardSaveAnimation: Bool
    @ObservedObject var passwordListViewModel: PasswordListViewModel
    @ObservedObject var passwordGeneratorViewModel: PasswordGeneratorViewModel
    @ObservedObject var settings: SettingsViewModel
    @Binding var isEditingPassword: Bool
    @Binding var editedPassword: String
    
    var body: some View {
        
        //Shown if password is not in editing state (initial state)
        
        if !isEditingPassword {
            
            NotEditingPasswordView(revealPassword: $revealPassword,
                                   password: $password,
                                   isEditingPassword: $isEditingPassword,
                                   editedPassword: $editedPassword,
                                   settings: settings)
            
        }
        
        //Shown if password is in editing state
        
        else if isEditingPassword {
            
            EditingPasswordView(editedPassword: $editedPassword,
                                isEditingPassword: $isEditingPassword,
                                password: $password,
                                key: $key,
                                passwordListViewModel: passwordListViewModel,
                                settings: settings)
            
        }
        
        //Copy to clipboard button
        Button(action: {
            
            settings.copyToClipboard(password: password)
            passwordGeneratorViewModel.copyPasswordHaptic()
            clipboardSaveAnimation = true
            
        },     label: {
            
            HStack {
                Spacer()
                Text("Copier")
                Spacer()
            }
            
        })
        .disabled(revealPassword ? false : true)
        
    }
}

extension PasswordSection {
    
    struct NotEditingPasswordView: View {
        
        @Binding var revealPassword: Bool
        @Binding var password: String
        @Binding var isEditingPassword: Bool
        @Binding var editedPassword: String
        @ObservedObject var settings: SettingsViewModel
        
        var body: some View {
            
            HStack {
                
                HStack {
                    Spacer()
                    Text(revealPassword ? password : "****************************")
                    Spacer()
                }
                
                Spacer()
                
                Button(action: {
                    
                    isEditingPassword.toggle()
                    editedPassword = password
                    
                }, label: {
                    
                    Image(systemName: "pencil")
                    
                })
                .foregroundColor(!revealPassword ? .gray : settings.colors[settings.accentColorIndex])
                .buttonStyle(PlainButtonStyle())
                .disabled(!revealPassword)
                
            }
        }
    }
    
    struct EditingPasswordView: View {
        
        @Binding var editedPassword: String
        @Binding var isEditingPassword: Bool
        @Binding var password: String
        @Binding var key: String
        @ObservedObject var passwordListViewModel:PasswordListViewModel
        @ObservedObject var settings:SettingsViewModel
        
        var body: some View {
            
            HStack {
                
                CocoaTextField("password", text: $editedPassword)
                    .keyboardType(.asciiCapable)
                    .isFirstResponder(true)
                    .disableAutocorrection(true)
                
                Button(action: {
                    
                    isEditingPassword.toggle()
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
    }
    
    struct PasswordSection_Previews: PreviewProvider {
        static var previews: some View {
            PasswordSection(password: .constant(""), revealPassword: .constant(true), key: .constant(""), clipboardSaveAnimation: .constant(true), passwordListViewModel: PasswordListViewModel(), passwordGeneratorViewModel: PasswordGeneratorViewModel(), settings: SettingsViewModel(), isEditingPassword: .constant(true), editedPassword: .constant(""))
        }
    }
}
