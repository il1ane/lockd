//
//  PasswordView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI
import MobileCoreServices
import LocalAuthentication
import CoreHaptics

struct PasswordGeneratorView: View {
    
    @ObservedObject var viewModel = PasswordGeneratorViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var isUnlocked = false
    @State private var uppercased = true
    @State private var specialCharacters = true
    @State private var numberOfCharacter = 20.0
    @State private var withNumbers = true
    @State private var generatedPassword = ""
    @State private var savePasswordSheetIsPresented = false
    @ObservedObject var settings: SettingsViewModel
    @ObservedObject var passwordViewModel: PasswordListViewModel
    @State private var showAnimation = false
    @State private var characters = [String]()
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Form {
                    
                    Section(header: Text("Mot de passe généré aléatoirement")) {
                        
                        HStack {
                            Spacer()
                            
                                    
                            HStack(spacing: 0) {
                                ForEach(characters, id: \.self) { character in
                                    
                                    Text(character).foregroundColor(viewModel.specialCharactersArray.contains(character) ? .pink : viewModel.numbersArray.contains(character) ? .teal : viewModel.alphabet.contains(character) ? .gray : .yellow)
                                }
                            }                                .font(numberOfCharacter > 25 ? .system(size: 15) : .body)
                            .animation(.easeOut(duration: 0.1))
                            Spacer()
                            Button(action: {
                                UIPasteboard.general.string = generatedPassword
                            }, label: {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(settings.colors[settings.accentColorIndex])
                                
                                
                            }).buttonStyle(PlainButtonStyle())
                        }
                        HStack {
                            Spacer()
                            Button(action: { savePasswordSheetIsPresented.toggle()
                                
                            }, label: {
                                Text("Ajouter au coffre fort")
                                    .foregroundColor(settings.colors[settings.accentColorIndex])
                              
                                
                            }).buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                    }
                    

                    
                    Section(header: Text("Nombre de caractères")) {
                        HStack {
                            
                            Slider(value: $numberOfCharacter, in: viewModel.passwordLenghtRange, step: 1)
                                .accentColor(numberOfCharacter < 9 ? settings.colors[settings.accentColorIndex].opacity(0.5) : numberOfCharacter < 14 ?  settings.colors[settings.accentColorIndex].opacity(0.7) : settings.colors[settings.accentColorIndex].opacity(1))
                            
                            Divider().frame(minWidth: 20)
                            
                            Text("\(Int(numberOfCharacter)) ")
                                .frame(minWidth: 25)
                            
                        }
                    }
                    
                    Section(header: Text("Inclure"), footer: Text("Note : chaque paramètre actif renforce la sécurité du mot de passe.").padding()) {
                        
                        Toggle(isOn: $specialCharacters, label: {
                            Text("Caractères spéciaux")
                        })
                        .toggleStyle(SwitchToggleStyle(tint: settings.colors[settings.accentColorIndex]))
                        Toggle(isOn: $uppercased, label: {
                            Text("Majuscules")
                        })
                        .toggleStyle(SwitchToggleStyle(tint: settings.colors[settings.accentColorIndex]))
                        Toggle(isOn: $withNumbers, label: {
                            Text("Chiffres")
                        })
                        .toggleStyle(SwitchToggleStyle(tint: settings.colors[settings.accentColorIndex]))
                    }
                    
                }.navigationBarTitle("Générateur")
                
                 .navigationBarItems(trailing: Button(action: {
                    
                    characters = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
                    generatedPassword = characters.joined()
                    
                }, label: {
                    Image(systemName: "die.face.5.fill")
                        
            }))
                
                if passwordViewModel.showAnimation {
                    
                    SavePasswordAnimation(settings: settings)
                        .onAppear(perform: { animationDisappear() })
                        .animation(.easeInOut(duration: 0.1))
    
                }
            }
            
            
            
        }.sheet(isPresented: $savePasswordSheetIsPresented ,  content: {
            SavePasswordView(password: $generatedPassword, sheetIsPresented: $savePasswordSheetIsPresented, generatedPasswordIsPresented: true, viewModel: passwordViewModel, settings: settings)
                .environment(\.colorScheme, colorScheme)
                .foregroundColor(settings.colors[settings.accentColorIndex])
            
        })
        
   
        //Triggers that generate a new password
        .onChange(of: numberOfCharacter, perform: { value in
            viewModel.sliderMediumHaptic()
            characters = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
        })
        .onChange(of: uppercased, perform: { value in
            characters = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
        })
        .onChange(of: specialCharacters, perform: { value in
            characters = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
        })
        .onChange(of: withNumbers, perform: { value in
            characters = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
        })
        .onAppear(perform: {
            characters = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            
        })
    }
    
     func animationDisappear() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            passwordViewModel.showAnimation = false
            print("Show animation")
            
            }
    
   }
}



struct PasswordGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView(settings: SettingsViewModel(), passwordViewModel: PasswordListViewModel())
    }
}

