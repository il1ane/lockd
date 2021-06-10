//
//  PasswordViewModel.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import Foundation
import CoreHaptics
import SwiftUI

final class PasswordGeneratorViewModel: ObservableObject {
    
    @Published var generatedPassword = [String]()
    
    let passwordLenghtRange = 1...30.0
    let alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    let specialCharactersArray: [String] = ["(",")","{","}","[","]","/","+","*","$",">",".","|","^","?", "&"]
    let numbersArray: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    
    func sliderHaptic(entropy: Double) {
        
        switch entropy {
        case 128.0...200:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            print("haptic feedback intensity : 1")
            generator.impactOccurred(intensity: 1)
        case 60.0...128:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            print("haptic feedback intensity : 0.8")
            generator.impactOccurred(intensity: 0.8)
        case 36.0...60:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            print("haptic feedback intensity : 0.6")
            generator.impactOccurred(intensity: 0.6)
        case 28.0...36:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            print("haptic feedback intensity : 0.4")
            generator.impactOccurred(intensity: 0.4)
        default:
            let generator = UIImpactFeedbackGenerator(style: .rigid)
            print("haptic feedback intensity : 0.2")
            generator.impactOccurred(intensity: 0.2)
        }

   }
    
    func calculatePasswordEntropy(password: String) -> Double {
        
        var pool = 0
        let lenght = password.count
        let lettersArray = Array(password)
        var uppercasedAlphabet: [String] = []
        
        for character in alphabet {
            uppercasedAlphabet.append(character.uppercased())
        }
        
        for char in lettersArray {
            if alphabet.contains(String(char)) {
                pool += alphabet.count
                break
            }
        }
        
        for char in lettersArray {
            if uppercasedAlphabet.contains(String(char)) {
                pool += uppercasedAlphabet.count
                break
            }
        }
        
        for char in lettersArray {
            if numbersArray.contains(String(char)) {
                pool += numbersArray.count
                break
            }
        }
        
        for char in lettersArray {
            if specialCharactersArray.contains(String(char)) {
                pool += specialCharactersArray.count
                break
            }
        }
        
        let entropy = log2(Double(pool))
        print("Password entropy : \(entropy * Double(lenght))")
        return entropy * Double(lenght)
        
    }
    
    func copyPasswordHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func generatePassword(lenght: Int, specialCharacters: Bool, uppercase: Bool, numbers: Bool) -> [String] {
        
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
    
    func lowercasePassword(lenght: Int) -> [String] {
        
        var password: [String] = [""]

            for _ in 0...lenght {
                password.append(alphabet.randomElement()!)
            }
        if password.joined().count != lenght {
            while password.joined().count > lenght {
                password.remove(at: 0)
            }
        }
                return password
    }
    
    func oneParameterPassword(lenght: Int, specialCharacters: Bool, uppercase: Bool, numbers: Bool) -> [String] {
        
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
                password.append(specialCharactersArray.randomElement()!)
            }
            password.shuffle()
            
            if password.joined().count != lenght {
                while password.joined().count > lenght {
                    password.remove(at: 0)
                }
            }
            
            return password
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
            return password
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
            return password
        }
        return password
    }
    
    func twoParameterPassword(lenght: Int, specialCharacters: Bool, uppercase: Bool, numbers: Bool) -> [String] {
        
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
                password.append(specialCharactersArray.randomElement()!)
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
            
            return password
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
            
            return password
        }
        
        if numbers && specialCharacters {

            for _ in 0...lenght / 3 {
                password.append(numbersArray.randomElement()!)
            }
            
            for _ in 0...lenght / 3 {
                password.append(specialCharactersArray.randomElement()!)
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
            
            return password
        }
       return password
    }
    
    func threeParameterPassword(lenght: Int) -> [String] {
        
        var password: [String] = [""]
        var uppercasedAlphabet: [String] = []
        
        for character in alphabet {
            uppercasedAlphabet.append(character.uppercased())
        }
        
        for _ in 0...lenght / 4 {
            password.append(uppercasedAlphabet.randomElement()!)
        }
        
        for _ in 0...lenght / 4 {
            password.append(specialCharactersArray.randomElement()!)
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
        
        return password
    }
    
}
