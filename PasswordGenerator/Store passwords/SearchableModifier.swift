//
//  SearchableModifier.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 26/09/2021.
//

import SwiftUI


struct SearchableModifier: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        if #available(iOS 15, *) {
            content.searchable(text: $text, placement: .navigationBarDrawer(displayMode: .automatic))
        } else {
            
        }
    }
}


