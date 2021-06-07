//
//  TextBindingManager.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 09/05/2021.
//

import Foundation

final class TextBindingManager: ObservableObject {
    
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    
    let characterLimit: Int

    init(limit: Int = 30) {
        characterLimit = limit
    }
}
