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
    
    @ObservedObject var viewModel = PasswordListViewModel()
    @State private var showPasswordView = false
    @State private var chosenKey = ""
    
    var body: some View {
        
        NavigationView {
            
            
            List {
                ForEach(viewModel.keys, id: \.self) { key in
                    HStack {
                        Button(action: {
                                chosenKey = key
                                showPasswordView.toggle() },
                               label: Text(key))
                    }
                }
            }.onAppear(perform: {
                viewModel.refreshKeys()
            })
            .navigationBarTitle("Coffre fort")
            }
       
            
        .sheet(isPresented: $showPasswordView, content: {
            PasswordView(key: $chosenKey, viewModel: viewModel, isPresented: $showPasswordView)
        })
    }
}


struct PasswordListView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordListView()
    }
}
