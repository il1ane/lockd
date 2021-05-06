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
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
