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
    @State private var useFaceID = false
    @State var biometricType: SettingsViewModel.BiometricType
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Sécurité")) {
                    
                    Text("Rate app")
                        Toggle(isOn: $useFaceID, label: {
                            Label(
                                title: { Text("Déverouillage biométrique") },
                                icon: { biometricType == .face ? Image(systemName: "faceid") : biometricType == .touch ? Image(systemName: "touchid") : Image(systemName: "mark") }
)
                        })
                        
                    Text("Delete all passwords")
                    }
                    Section(header: Text("Personalisation")) {
                        Picker(selection: $selectedColor, label: Text("\(selectedColor.rawValue)"), content: {
                            ForEach(Colors.allCases) { color in
                                Text(color.rawValue).tag(color)
                            }
                        }).pickerStyle(MenuPickerStyle())
                        
                    }
                }.onChange(of: selectedColor, perform: { value in
                    settings.updateColor(color: Color(selectedColor.rawValue))
                })
            }.onAppear(perform: {
                biometricType = settings.biometricType()
            })
            .navigationBarTitle("Préférences")
        }.accentColor(settings.accentColor)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(biometricType: SettingsViewModel.BiometricType.face)
    }
}
