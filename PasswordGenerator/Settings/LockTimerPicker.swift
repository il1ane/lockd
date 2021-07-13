//
//  LockTimerPicker.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 08/07/2021.
//

import SwiftUI

struct LockTimerPicker: View {
    
    @ObservedObject var settingsViewModel: SettingsViewModel
    
    var body: some View {
        
        Picker(selection: $settingsViewModel.autoLock,
               label: Label(
                
                title: { Text("Vérouillage auto.") },
                icon: { Image(systemName: "lock.fill") }),
               
               content: {
                
                Text("Immédiat").tag(0)
                Text("1 minute").tag(1)
                Text("5 minutes").tag(5)
                Text("15 minutes").tag(15)
                Text("30 minutes").tag(30)
                
               })
    }
}

struct LockTimerPicker_Previews: PreviewProvider {
    static var previews: some View {
        LockTimerPicker(settingsViewModel: SettingsViewModel())
    }
}
