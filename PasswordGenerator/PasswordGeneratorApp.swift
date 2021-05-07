//
//  PasswordGeneratorApp.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import SwiftUI

@main
struct PasswordGeneratorApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .accentColor(.green).preferredColorScheme(.dark)
        }
    }
}
