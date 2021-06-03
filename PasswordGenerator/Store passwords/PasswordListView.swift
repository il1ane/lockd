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
    @Environment(\.colorScheme) var colorScheme
    @State private var showPasswordView = false
    @State private var chosenKey = ""
    @State private var addSheetIsShowing = false
    @State private var password = ""
    @ObservedObject var settings:SettingsViewModel
    @State private var title = ""
    @State private var showAnimation = false
    @State private var searchText = ""
    @State private var username = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                SearchBar(NSLocalizedString("Rechercher un mot de passe", comment: ""), text: $searchText)
                    .searchBarStyle(.minimal)
                    .frame(maxWidth: 370)
                
                Spacer()
                ZStack {
                    
                    if passwordViewModel.keys.isEmpty == false {
                        
                        Form {
                            
                            Section(header: HStack {
                                Text("Total : \( self.passwordViewModel.keys.filter {  self.searchText.isEmpty ? true : $0.components(separatedBy: passwordViewModel.separator)[2].starts(with: self.searchText) }.count )")
                                Spacer()
                                
                                Picker(selection: $passwordViewModel.sortSelection, label: passwordViewModel.sortSelection == 0 ? Text("A-Z") : Text("Z-A"), content: {
                                    Text("A-Z").tag(0)
                                    Text("Z-A").tag(1)
                                })
                                .pickerStyle(MenuPickerStyle())
                            }) {
                                List {
                                    ForEach(passwordViewModel.sortSelection == 0 ?
                                                
                                                self.passwordViewModel.keys.sorted().filter {
                                                    self.searchText.isEmpty ? true : $0.components(separatedBy: passwordViewModel.separator)[0].starts(with: self.searchText) }
                                                :
                                                self.passwordViewModel.keys.sorted().reversed().filter  {  self.searchText.isEmpty ? true :
                                                    $0.components(separatedBy: passwordViewModel.separator)[0].starts(with: self.searchText) }, id: \.self) { key in
                                        
                                        let keyArray = key.components(separatedBy: passwordViewModel.separator)
                                        
                                        HStack {
                                            Button(action: {
    
                                                chosenKey = key
                                                showPasswordView.toggle()
                                                title = keyArray[0]
                                                username = keyArray[1]
                                                print(keyArray.count)
                                                print(keyArray[0])
                                                print(keyArray[1])
                                               
                                                print(key)
                                            },
                                            label: Text("\(keyArray[0])"))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    VStack {}
                        .sheet(isPresented: $addSheetIsShowing, content: {
                            SavePasswordView(password: $password, sheetIsPresented: $addSheetIsShowing, generatedPasswordIsPresented: false, viewModel: passwordViewModel, settings: settings).environment(\.colorScheme, colorScheme)
                                .accentColor(settings.colors[settings.accentColorIndex])
                        })
                        .onAppear(perform: {
                            passwordViewModel.getAllKeys()
                            passwordViewModel.getAllUsernames()
                            print(passwordViewModel.keys)
                        })
                        .navigationBarTitle("Coffre fort")
                        .navigationBarItems(trailing: Button(action: { addSheetIsShowing.toggle() }, label: {
                            Image(systemName: "plus")
                        }))
                    
                    if passwordViewModel.showAnimation {
                        
                        SavePasswordAnimation(settings: settings)
                            .onAppear(perform: { animationDisappear() })
                            .animation(.easeInOut(duration: 0.5))
                        
                    }
                }
                
                .sheet(isPresented: $showPasswordView, onDismiss: passwordViewModel.getAllKeys ,content: {
                    PasswordView(key: $chosenKey, viewModel: passwordViewModel, isPresented: $showPasswordView, settings: settings, title: $title, username: $username)
                        .environment(\.colorScheme, colorScheme)
                        .accentColor(settings.colors[settings.accentColorIndex])
                })
            }
        }
    }
    
    func animationDisappear() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            passwordViewModel.showAnimation = false
            print("Show animation")
        }
    }
}


struct PasswordListView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordListView(passwordViewModel: PasswordListViewModel(), settings: SettingsViewModel())
    }
}
