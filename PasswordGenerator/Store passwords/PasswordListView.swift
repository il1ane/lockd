//
//  PasswordListView.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI
import Security
import KeychainSwift

struct PasswordListView: View {
    
    @ObservedObject var viewModel: PasswordListViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showPasswordView = false
    @State private var chosenKey = ""
    @State private var addSheetIsShowing = false
    @State private var password = ""
    @ObservedObject var settings:SettingsViewModel
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                if viewModel.keys.isEmpty {
                    
                    VStack {
                    Spacer()
                    Text("🤷")
                    .font(.system(size: 100))
                    Text("Aucun mot de passe a l'horizon...").bold()
                    Spacer()
                    }
                    
                }
                
                if viewModel.keys.isEmpty == false {
                VStack {
                List {
                    ForEach(viewModel.keys, id: \.self) { key in
                        HStack {
                            Button(action: {
                                    chosenKey = key
                                    showPasswordView.toggle() },
                                   label: Text(key))
                        }
                    }
                }
            }
                }
                Spacer()
                .sheet(isPresented: $addSheetIsShowing, content: {
                    SavePasswordView(password: $password, sheetIsPresented: $addSheetIsShowing, generatedPasswordIsPresented: false, viewModel: viewModel, settings: settings).environment(\.colorScheme, colorScheme)
                        .accentColor(settings.colors[settings.accentColorIndex])
                })
                .onAppear(perform: {
                    viewModel.refreshKeys()
                })
                .navigationBarTitle("Coffre fort")
                .navigationBarItems(trailing: Button(action: { addSheetIsShowing.toggle() }, label: {
                    Image(systemName: "plus")
                }))
                }
           
                
            .sheet(isPresented: $showPasswordView, content: {
                PasswordView(key: $chosenKey, viewModel: viewModel, isPresented: $showPasswordView, settings: settings)
                    .navigationBarTitle("ddd")
                    .environment(\.colorScheme, colorScheme)
                    .accentColor(settings.colors[settings.accentColorIndex])
        })
        }
    }
}


struct PasswordListView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordListView(viewModel: PasswordListViewModel(), settings: SettingsViewModel())
    }
}
