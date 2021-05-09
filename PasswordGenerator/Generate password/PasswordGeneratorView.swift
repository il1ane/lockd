//
//  PasswordView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI
import MobileCoreServices

struct PasswordGeneratorView: View {
    
    @ObservedObject var viewModel = PasswordGeneratorViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var uppercased = true
    @State private var specialCharacters = true
    @State private var numberOfCharacter = 20.0
    @State private var withNumbers = true
    @State private var generatedPassword = ""
    @State private var savePasswordSheetIsPresented = false
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Mot de passe généré aléatoirement")) {
                    
                    HStack {
                        Spacer()
                        Text(generatedPassword).foregroundColor(.gray).font(numberOfCharacter > 25 ? .system(size: 15) : .body).animation(.easeOut)
                        Spacer()
                        Button(action: {
                            UIPasteboard.general.string = generatedPassword
                        }, label: {
                            Image(systemName: "doc.on.doc")
                            .foregroundColor(.green)
                            
                        }).buttonStyle(PlainButtonStyle())
                    }
                    HStack {
                        Spacer()
                        Button(action: { savePasswordSheetIsPresented.toggle()
                            
                        }, label: {
                            Text("Ajouter au coffre fort")
                            .foregroundColor(.green)
                            
                        }).buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }
                
                Section(header: Text("Nombre de caractères")) {
                    HStack {
                        Slider(value: $numberOfCharacter, in: viewModel.range, step: 1).accentColor(numberOfCharacter < 9 ? .red : numberOfCharacter < 14 ?  .orange : .green)
                        
                        Divider().frame(minWidth: 20)
                        
                        Text("\(Int(numberOfCharacter)) ")
                            .frame(minWidth: 25)
                        
                    }
                }
                
                Section(header: Text("Inclure"), footer: Text("Note : chaque paramètre actif renforce la sécurité du mot de passe.").padding()) {
                    
                    Toggle(isOn: $specialCharacters, label: {
                        Text("Caractères spéciaux")
                    })
                    Toggle(isOn: $uppercased, label: {
                        Text("Majuscules")
                    })
                    Toggle(isOn: $withNumbers, label: {
                        Text("Chiffres")
                    })
                }
                
                
            }.navigationBarTitle("Générateur")
            
             .navigationBarItems(trailing: Button(action: {
                generatedPassword = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            }, label: {
                Image(systemName: "die.face.5.fill")
                    .foregroundColor(.green)
            }))
            
        }.sheet(isPresented: $savePasswordSheetIsPresented, content: {
            SavePasswordView(password: $generatedPassword, sheetIsPresented: $savePasswordSheetIsPresented)
            .environment(\.colorScheme, colorScheme)
            .accentColor(.green)
        })
   
        //Triggers that generate a new password
        .onChange(of: numberOfCharacter, perform: { value in
            generatedPassword = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
        })
        .onChange(of: uppercased, perform: { value in
            generatedPassword = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
        })
        .onChange(of: specialCharacters, perform: { value in
            generatedPassword = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
        })
        .onChange(of: withNumbers, perform: { value in
            generatedPassword = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
        })
        .onAppear(perform: {
            generatedPassword = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
        })
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordGeneratorView()
    }
}
