//
//  PasswordViewModel.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import Foundation

class PasswordViewModel: ObservableObject {
    
    @Published var generatedPassword = ""
    
    let alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    let special: [String] = ["(",")","{","}","[","]","/","+","*","$",">",".","|","^","?"]
    let numbersArray: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    func generatePassword(lenght: Int, specialCharacters: Bool, uppercase: Bool, numbers: Bool) -> String {
        
        //All parameters
        if uppercase && specialCharacters && numbers {
            return threeParameterPassword(lenght: lenght)
        }
        
        //Two parameters
        if uppercase && specialCharacters || uppercase && numbers || numbers && specialCharacters {
            return twoParameterPassword(lenght: lenght, specialCharacters: specialCharacters, uppercase: uppercase, numbers: numbers)
        }
        
        //One parameter
        if uppercase || specialCharacters || numbers {
            return oneParameterPassword(lenght: lenght, specialCharacters: specialCharacters, uppercase: uppercase, numbers: numbers)
        }
        
        else {
            return lowercasePassword(lenght: lenght)
        }
    }
    
    func lowercasePassword(lenght: Int) -> String {
        
        var password: [String] = [""]

            for _ in 0...lenght {
                password.append(alphabet.randomElement()!)
            }
                return password.joined()
    }
    
    func oneParameterPassword(lenght: Int, specialCharacters: Bool, uppercase: Bool, numbers: Bool) -> String {
        
        var password: [String] = [""]
        var uppercasedAlphabet: [String] = []
        
        for character in alphabet {
            uppercasedAlphabet.append(character.uppercased())
        }
        
        if specialCharacters {
            for _ in 0...lenght / 2 {
                password.append(alphabet.randomElement()!)
            }
            
            for _ in 0...lenght / 2 {
                password.append(special.randomElement()!)
            }
            password.shuffle()
            
            if password.joined().count != lenght {
                while password.joined().count > lenght {
                    password.remove(at: 0)
                }
            }
            
            return password.joined()
        }
        
        if uppercase {
            for _ in 0...lenght / 2 {
                password.append(alphabet.randomElement()!)
            }
            
            for _ in 0...lenght / 2 {
                password.append(uppercasedAlphabet.randomElement()!)
            }
            password.shuffle()
            
            if password.joined().count != lenght {
                while password.joined().count > lenght {
                    password.remove(at: 0)
                }
            }
            return password.joined()
        }
        
        if numbers {
            for _ in 0...lenght / 2 {
                password.append(alphabet.randomElement()!)
            }
            
            for _ in 0...lenght / 2 {
                password.append(numbersArray.randomElement()!)
            }
            password.shuffle()
            
            if password.joined().count != lenght {
                while password.joined().count > lenght {
                    password.remove(at: 0)
                }
            }
            return password.joined()
        }
        
        else {
            return "Error"
        }
    }
    
    func twoParameterPassword(lenght: Int, specialCharacters: Bool, uppercase: Bool, numbers: Bool) -> String {
        
        var password: [String] = [""]
        var uppercasedAlphabet: [String] = []
        
        for character in alphabet {
            uppercasedAlphabet.append(character.uppercased())
        }
        
        if uppercase && specialCharacters {

            for _ in 0...lenght / 3 {
                password.append(uppercasedAlphabet.randomElement()!)
            }
            
            for _ in 0...lenght / 3 {
                password.append(special.randomElement()!)
            }
            
            for _ in 0...lenght / 3 {
                password.append(alphabet.randomElement()!)
            }
            
            password.shuffle()
            
            if password.joined().count != lenght {
                while password.joined().count > lenght {
                    password.remove(at: 0)
                }
            }
            
            return password.joined()
        }
        
        if uppercase && numbers {

            for _ in 0...lenght / 3 {
                password.append(uppercasedAlphabet.randomElement()!)
            }
            
            for _ in 0...lenght / 3 {
                password.append(numbersArray.randomElement()!)
            }
            
            for _ in 0...lenght / 3 {
                password.append(alphabet.randomElement()!)
            }
            
            password.shuffle()
            
            if password.joined().count != lenght {
                while password.joined().count > lenght {
                    password.remove(at: 0)
                }
            }
            
            return password.joined()
        }
        
        if numbers && specialCharacters {

            for _ in 0...lenght / 3 {
                password.append(numbersArray.randomElement()!)
            }
            
            for _ in 0...lenght / 3 {
                password.append(special.randomElement()!)
            }
            
            for _ in 0...lenght / 3 {
                password.append(alphabet.randomElement()!)
            }
            
            password.shuffle()
            
            if password.joined().count != lenght {
                while password.joined().count > lenght {
                    password.remove(at: 0)
                }
            }
            
            return password.joined()
        }
        
        else {
            return "Error"
        }
       
    }
    
    func threeParameterPassword(lenght: Int) -> String {
        
        var password: [String] = [""]
        var uppercasedAlphabet: [String] = []
        
        for character in alphabet {
            uppercasedAlphabet.append(character.uppercased())
        }
        
        for _ in 0...lenght / 4 {
            password.append(uppercasedAlphabet.randomElement()!)
        }
        
        for _ in 0...lenght / 4{
            password.append(special.randomElement()!)
        }
        
        for _ in 0...lenght / 4 {
            password.append(alphabet.randomElement()!)
        }
        
        for _ in 0...lenght / 4 {
            password.append(numbersArray.randomElement()!)
        }
        
        password.shuffle()
        
        if password.joined().count != lenght {
            while password.joined().count > lenght {
                password.remove(at: 0)
            }
        }
        
        return password.joined()
    }
    
}
