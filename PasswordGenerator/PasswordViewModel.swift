//
//  PasswordViewModel.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import Foundation

class PasswordViewModel: ObservableObject {
    
    @Published var password = ""
    
    func generatePassword(lenght: Int, specialCharacters: Bool, uppercase: Bool) -> String {
        
        let alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        var uppercasedAlphabet: [String] = []
        var password: [String] = [""]
        
        if uppercase {
        for character in alphabet {
            uppercasedAlphabet.append(character.uppercased())
        }
            for _ in 0...lenght {
                password.append(uppercasedAlphabet.randomElement()!)
            }
            return password.joined()
        }
        
        return password.joined()
    }
    
}
