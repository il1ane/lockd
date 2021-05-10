//
//  SettingsView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings = SettingsViewModel()
    @State private var selectedColor = Colors.green
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Sécurité")) {
                    Text("Rate app")
                    Text("Face ID/Touch ID & Passcode")
                    Text("Delete all passwords")
                    }
                    Section(header: Text("Personalisation")) {
                        Picker(selection: $selectedColor, label: Text("\(selectedColor.rawValue)").foregroundColor(Color(selectedColor.rawValue)), content: {
                            ForEach(Colors.allCases) { color in
                                Text(color.rawValue).tag(color)
                            }
                        }).pickerStyle(MenuPickerStyle())
                        
                    }
                }
            }.navigationBarTitle("Préférences")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
