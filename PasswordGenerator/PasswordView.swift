//
//  PasswordView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI

struct PasswordView: View {
    
    @State private var withUpercase = true
    @State private var withSpecialCharacter = true
    @State private var numberOfCharacter = 8.0
    @State private var withNumbers = true
    @State private var result = "PSWRD"
    let range = 1...20.0
    
    var body: some View {
        
        NavigationView {
            Form {
                
                Section(header: Text("Ajuster la longeur du mot de passe")) {
                    
                    HStack {
                        Spacer()
                        Text(result).foregroundColor(.gray)
                        Spacer()
                        Button(action: {
                        //Todo : find a way to copy to clipboard
                        }, label: {
                            Image(systemName: "doc.on.doc")
                        }).buttonStyle(PlainButtonStyle())
                    }
                  
                    
                    Slider(value: $numberOfCharacter, in: range, step: 1).accentColor(numberOfCharacter < 6 ? .red : numberOfCharacter < 8 ?  .orange : .green)
                    
                     HStack {
                        Spacer()
                        if numberOfCharacter > 1 {
                        Text("\(Int(numberOfCharacter)) caractères").foregroundColor(numberOfCharacter < 6 ? .red : numberOfCharacter < 8 ?  .orange : .green)
                        }
                        else {
                         Text("\(Int(numberOfCharacter)) caractère")
                            .foregroundColor(.red)
                        }
                        Spacer()
                    }
                }
                
                Section(header: Text("paramètres"), footer: Text("Note : chaque paramètre actif renforce la sécurité du mot de passe.").padding()) {
                    Toggle(isOn: $withUpercase, label: {
                        Text("Majuscules")
                    })
                    Toggle(isOn: $withSpecialCharacter, label: {
                        Text("Caractères spéciaux")
                    })
                    Toggle(isOn: $withNumbers, label: {
                        Text("Nombres")
                    })
                }
                
            }.navigationBarTitle("Générateur")
             .navigationBarItems(trailing: Button(action: {
                //func that generate another password
            }, label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .foregroundColor(.green)
            }))
        }
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView()
    }
}
