//
//  SettingsViewModel.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 10/05/2021.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    
    @Published var accentColor = Color.green
    
    let colors = [Color.green, Color.blue, Color.red, Color.pink, Color.purple, Color.yellow]
}

enum Colors: String, Identifiable, CaseIterable{
    case green
    case blue
    case red
    case pink
    case purple
    case yellow
    
    var id: String { self.rawValue }
}
