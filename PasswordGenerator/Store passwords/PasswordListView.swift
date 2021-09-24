//
//  PasswordListView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI
import SwiftUIX
import Security
import KeychainSwift

struct PasswordListView: View {
    
    @ObservedObject var passwordViewModel: PasswordListViewModel
    @State private var password = ""
    @Environment(\.colorScheme) var colorScheme
    @State private var showPasswordView = false
    @State private var addSheetIsShowing = false
    @ObservedObject var settings:SettingsViewModel
    @ObservedObject var passwordGeneratorViewModel:PasswordGeneratorViewModel
    @ObservedObject var settingsViewModel:SettingsViewModel
    @State private var showAnimation = false
    @State private var searchText = ""
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                HStack {
                    SearchBar(NSLocalizedString("Rechercher un mot de passe", comment: ""), text: $searchText)
                        .returnKeyType(.done)
                        .searchBarStyle(.minimal)
                        .showsCancelButton(true)
                        .onCancel {
                            searchText = ""
                        }
                        .frame(maxWidth: 370)
                }
                
                Spacer()
                ZStack {
                    
                    if passwordViewModel.keys.isEmpty == false {
                        
                        Form {
                            
                            Section(header: HStack {
                                Text("Total : \( self.passwordViewModel.keys.filter {  self.searchText.isEmpty ? true : $0.components(separatedBy: passwordViewModel.separator)[0].starts(with: self.searchText) }.count )")
                                Spacer()
                                
                                Picker(selection: $passwordViewModel.sortSelection, label: passwordViewModel.sortSelection == 0 ? Text("A-Z") : Text("Z-A"), content: {
                                    Text("A-Z").tag(0)
                                    Text("Z-A").tag(1)
                                })
                                .pickerStyle(MenuPickerStyle())
                            }) {
                                List {
                                    ForEach(enumerating: passwordViewModel.sortSelection == 0 ?
                                            
                                                self.passwordViewModel.keys.sorted().filter {
                                                    self.searchText.isEmpty ? true : $0.lowercased().components(separatedBy: passwordViewModel.separator)[0].starts(with: self.searchText.lowercased()) }
                                                :
                                                self.passwordViewModel.keys.sorted().reversed().filter  {  self.searchText.isEmpty ? true :
                                        $0.lowercased().components(separatedBy: passwordViewModel.separator)[0].starts(with: self.searchText.lowercased()) }, id: \.self) { keys,key in
                                        
                                        let keyArray = key.components(separatedBy: passwordViewModel.separator)
                                        
                                        let title = keyArray[0]
                                        let username = keyArray[1]
                                            
                                        
                                        HStack {
                                            NavigationLink(destination: PasswordView(key: key, passwordListViewModel: passwordViewModel, passwordGeneratorViewModel: passwordGeneratorViewModel, settings: settingsViewModel, title: title, username: username)) {
                                                Label(title, systemImage: "key")
                                            }
//                                                
//                                           
//
                                    }
                                }
                            }
                        }
                    }
                }

                    
                    VStack {}
                        .sheet(isPresented: $addSheetIsShowing, content: {
                            SavePasswordView(password: $password, sheetIsPresented: $addSheetIsShowing, generatedPasswordIsPresented: false, viewModel: passwordViewModel, settings: settings)
                                .environment(\.colorScheme, colorScheme)
                                .accentColor(settings.colors[settings.accentColorIndex])
                        })
                        
                        
                    VStack {}
                        .navigationBarTitle("Coffre fort")
                        
                        .navigationBarItems(trailing: Button(action: { addSheetIsShowing.toggle() }, label: {
                            Image(systemName: "plus")
                        }))
                }
            }
            
            .onAppear(perform: {
                passwordViewModel.getAllKeys()
            })
                        
        }
    }
}


struct PasswordListView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordListView(passwordViewModel: PasswordListViewModel(), settings: SettingsViewModel(), passwordGeneratorViewModel: PasswordGeneratorViewModel(), settingsViewModel: SettingsViewModel())
    }
}
