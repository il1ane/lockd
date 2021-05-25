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
    
    @ObservedObject var passwordViewModel: PasswordListViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showPasswordView = false
    @State private var chosenKey = ""
    @State private var addSheetIsShowing = false
    @State private var password = ""
    @ObservedObject var settings:SettingsViewModel
    @State private var currentUsername = ""
    @State private var showAnimation = false
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                if passwordViewModel.keys.isEmpty {
                    
                    VStack {
                    Spacer()
                    Text("🤷")
                    .font(.system(size: 100))
                    Text("Aucun mot de passe a l'horizon...").bold()
                    Spacer()
                    }
                    
                }
                
                if passwordViewModel.keys.isEmpty == false {
                Form {
                    Section(header: Text("Total : \(passwordViewModel.keys.count)")) {
                        List {
                        ForEach(passwordViewModel.keys, id: \.self) { key in
                            let username = key.components(separatedBy: passwordViewModel.separator)
                            HStack {
                                Button(action: {
                                        chosenKey = key
                                        showPasswordView.toggle()
                                        currentUsername = username[1]
                                },
                                label: Text("\(username[1])").foregroundColor(settings.appAppearance == "Nuit" ? .white : .black))
                            }
                        }
                    }
                }
            }
        }
                VStack{}
                .sheet(isPresented: $addSheetIsShowing, content: {
                    SavePasswordView(password: $password, sheetIsPresented: $addSheetIsShowing, generatedPasswordIsPresented: false, viewModel: passwordViewModel, settings: settings).environment(\.colorScheme, colorScheme)
                        .accentColor(settings.colors[settings.accentColorIndex])
                })
                .onAppear(perform: {
                    passwordViewModel.getAllKeys()
                    passwordViewModel.getAllUsernames()
                })
                .navigationBarTitle("Coffre fort")
                .navigationBarItems(trailing: Button(action: { addSheetIsShowing.toggle() }, label: {
                    Image(systemName: "plus")
                }))
                
                }
            
           
                
            .sheet(isPresented: $showPasswordView, content: {
                PasswordView(key: $chosenKey, viewModel: passwordViewModel, isPresented: $showPasswordView, settings: settings, username: $currentUsername)
                    .environment(\.colorScheme, colorScheme)
                    .accentColor(settings.colors[settings.accentColorIndex])
        })
            
        }
        
    }
    func animationDisappear() {
       
       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           passwordViewModel.showAnimation = false
           showAnimation = false
           print("Show animation")
               }
   }
   
    func successHaptic() {
       let generator = UINotificationFeedbackGenerator()
       generator.notificationOccurred(.success)
       print("Simple haptic")
   }
}


struct PasswordListView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordListView(passwordViewModel: PasswordListViewModel(), settings: SettingsViewModel())
    }
}
