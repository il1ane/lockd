//
//  PasswordView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI
import MobileCoreServices
import LocalAuthentication

struct PasswordGeneratorView: View {
    
 
    @ObservedObject var viewModel = PasswordGeneratorViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var isUnlocked = false
    @State private var uppercased = true
    @State private var specialCharacters = true
    @State private var characterCount = 20.0
    @State private var withNumbers = true
    @State private var generatedPassword = ""
    @State private var savePasswordSheetIsPresented = false
    @ObservedObject var settings: SettingsViewModel
    @ObservedObject var passwordViewModel: PasswordListViewModel
    @State private var showAnimation = false
    @State private var characters = [String]()
    @State private var clipboardSaveAnimation = false
    @State private var currentPasswordEntropy = 0.0
    @State private var entropySheetIsPresented = false
    @State private var strenghtMeterIsShowing = false
    @State private var copiedPassword = ""
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                Form {
                    
                    Section(header: Text("Mot de passe généré aléatoirement")) {
                        
                        HStack {
                            
                            Spacer()
                            
                            HStack(spacing: 0.5) {
                                ForEach(characters, id: \.self) { character in

                                    Text(character)
                                        .foregroundColor(viewModel.specialCharactersArray.contains(character) ? Color.init(hexadecimal: "#f16581") : viewModel.numbersArray.contains(character) ? Color.init(hexadecimal: "#4EB3BC") : viewModel.alphabet.contains(character) ? .gray : Color.init(hexadecimal: "#ffbc42"))
                                }
                            }
                            .font(characterCount > 25 ? .system(size: 15) : .body)
                            .animation(.easeOut(duration: 0.1))
                            
                            Spacer()
                            
                            Button(action: {
                            
                                clipboardSaveAnimation = true
                                settings.copyToClipboard(password: generatedPassword)
                                viewModel.copyPasswordHaptic()
                    
                                
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
                    
                    Section(header: HStack {
                        if !strenghtMeterIsShowing {
                        Text("Nombre de caractères:")
                        Text("\(Int(characterCount))")
                        } else {
                            Text("Force du mot de passe:")
                            Text(entropyText(entropy: currentPasswordEntropy))
                                .foregroundColor(entropyColor(entropy: currentPasswordEntropy))
                        }
                        Spacer()
                        Button(action: {
                            
                            
                            passwordViewModel.heavyHaptic()
                            
                            withAnimation {
                                strenghtMeterIsShowing.toggle()
                            }
                            
                        }, label:
                                !strenghtMeterIsShowing ? Image(systemName: "info.circle") : Image(systemName: "info.circle.fill")
    
                        )
                            .font(.body)
                    }) {
                        
                        HStack {
                            
                            if !strenghtMeterIsShowing {
                            Slider(value: $characterCount, in: viewModel.passwordLenghtRange, step: 1)
                                    .transition(.opacity)
                                    .transition(.move(edge: .top))
                                    .animation(.easeOut(duration: 0.8))

                            } else {
                                StrenghtMeterView(entropy: currentPasswordEntropy, characterCount: characterCount, combinaisons: viewModel.possibleCombinaisons, lenght: generatedPassword.count)
                                    .transition(.move(edge: .top))
                                    .animation(.easeInOut)
                                    
                            }
                        }
    
                        VStack(alignment: .leading) {
                        if !strenghtMeterIsShowing {
                
                            
                            Button(action: {
                                
                                viewModel.generateButtonHaptic()
                                characters = viewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
                                    generatedPassword = characters.joined()
                                    currentPasswordEntropy = viewModel.calculatePasswordEntropy(password: characters.joined())
                                    viewModel.adaptativeSliderHaptic(entropy: currentPasswordEntropy)
                                
                            },
                                   label: {
                         
                                HStack {
                                    Spacer()
                                Text("Générer")
                                    Spacer()
                                }
                        
                                    
                            })
                            .foregroundColor(settings.colors[settings.accentColorIndex])
                            .buttonStyle(PlainButtonStyle())
                            .transition(.opacity)
                            
                        } else {
                            Slider(value: $characterCount, in: viewModel.passwordLenghtRange, step: 1)
                                .animation(.easeInOut(duration: 0.7))
                            
                        }
                        }
                    }
                    
                    Section(header: Text("Inclure"), footer: Text("Note : chaque paramètre actif renforce la sécurité du mot de passe.").padding()) {
                        
                        Toggle(isOn: $specialCharacters, label: {
                            HStack {
                                Text("Caractères spéciaux")
                                Text("&-$").foregroundColor(Color.init(hexadecimal: "#f16581"))
                            }
                        })
                        .toggleStyle(SwitchToggleStyle(tint: settings.colors[settings.accentColorIndex]))
                        Toggle(isOn: $uppercased, label: {
                            HStack {
                                Text("Majuscules")
                                Text("A-Z").foregroundColor(Color.init(hexadecimal: "#ffbc42"))
                            }
                            
                        })
                        .toggleStyle(SwitchToggleStyle(tint: settings.colors[settings.accentColorIndex]))
                        Toggle(isOn: $withNumbers, label: {
                            HStack {
                                Text("Chiffres")
                                Text("0-9").foregroundColor(Color.init(hexadecimal: "#4EB3BC"))
                            }
                        })
                        .toggleStyle(SwitchToggleStyle(tint: settings.colors[settings.accentColorIndex]))
                    }
                    
                }
                .navigationBarTitle("Générateur")
            
            }
            .popup(isPresented: $passwordViewModel.showAnimation, type: .toast, position: .top, autohideIn: 2) {
                VStack(alignment: .center) {
                    Spacer()
                        .frame(height: UIScreen.main.bounds.height / 22)
                    Label("Ajouté au coffre", systemImage: "checkmark.circle.fill")
                    .padding(14)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(30)
                }

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
        }
        
        .sheet(isPresented: $savePasswordSheetIsPresented ,  content: {
            SavePasswordView(password: $generatedPassword, sheetIsPresented: $savePasswordSheetIsPresented, generatedPasswordIsPresented: true, viewModel: passwordViewModel, settings: settings)
                .environment(\.colorScheme, colorScheme)
                .foregroundColor(settings.colors[settings.accentColorIndex])
        })
        .onChange(of: characterCount, perform: { _ in
            characters = viewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            currentPasswordEntropy = viewModel.calculatePasswordEntropy(password: characters.joined())
            viewModel.adaptativeSliderHaptic(entropy: currentPasswordEntropy)
        })
        .onChange(of: uppercased, perform: { _ in
            characters = viewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            currentPasswordEntropy = viewModel.calculatePasswordEntropy(password: characters.joined())
        })
        .onChange(of: specialCharacters, perform: { _ in
            characters = viewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            currentPasswordEntropy = viewModel.calculatePasswordEntropy(password: characters.joined())
        })
        .onChange(of: withNumbers, perform: { _ in
            characters = viewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            currentPasswordEntropy = viewModel.calculatePasswordEntropy(password: characters.joined())
        })
        .onAppear(perform: {
            characters = viewModel.generatePassword(lenght: Int(characterCount), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            generatedPassword = characters.joined()
            currentPasswordEntropy = viewModel.calculatePasswordEntropy(password: characters.joined())
        })
    }
}

struct PasswordGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView(settings: SettingsViewModel(), passwordViewModel: PasswordListViewModel())
    }
}

