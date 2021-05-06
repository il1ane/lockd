//
//  PasswordView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI
import MobileCoreServices

struct PasswordView: View {
    
    @ObservedObject var viewModel = PasswordViewModel()
    @State private var uppercased = true
    @State private var specialCharacters = true
    @State private var numberOfCharacter = 8.0
    @State private var withNumbers = true
    @State private var result = ""
    let range = 0...20.0
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Ajuster la longeur du mot de passe")) {
                    
                    HStack {
                        Spacer()
                        Text(result).foregroundColor(.gray)
                        Spacer()
                        Button(action: {
                        UIPasteboard.general.string = result
                        }, label: {
                            Image(systemName: "doc.on.doc")
                        }).buttonStyle(PlainButtonStyle())
                    }
                  
                    
                    Slider(value: $numberOfCharacter, in: range, step: 1).accentColor(numberOfCharacter < 6 ? .red : numberOfCharacter < 8 ?  .orange : .green)
                    
                     HStack {
                        Spacer()
                        if numberOfCharacter > 1 {
                        Text("\(Int(numberOfCharacter + 1)) caractères").foregroundColor(numberOfCharacter < 6 ? .red : numberOfCharacter < 8 ?  .orange : .green)
                        }
                        else {
                         Text("\(Int(numberOfCharacter + 1)) caractère")
                            .foregroundColor(.red)
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("paramètres"), footer: Text("Note : chaque paramètre actif renforce la sécurité du mot de passe.").padding()) {
                    
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
                result = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
            }, label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(.green)
            }))
        }.onChange(of: numberOfCharacter, perform: { value in
            result = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
        })
        .onChange(of: uppercased, perform: { value in
            result = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
        })
        .onChange(of: specialCharacters, perform: { value in
            result = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
        })
        .onChange(of: withNumbers, perform: { value in
            result = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
        })
        .onAppear(perform: {
            result = viewModel.generatePassword(lenght: Int(numberOfCharacter), specialCharacters: specialCharacters, uppercase: uppercased, numbers: withNumbers)
        })
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
