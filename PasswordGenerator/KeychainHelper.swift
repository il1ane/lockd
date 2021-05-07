//
//  KeychainHelper.swift
//  PasswordGenerator
//
//  Created by Iliane Zedadra on 06/05/2021.
//

import Foundation

enum KeychainErrorType {
    case serviceError
    case badDataError
    case itemNotFoundError
    case unableToConvertStringError
}

struct KeychainError: Error {
    var message: String?
    var type: KeychainErrorType
    
    init(status: OSStatus, type: KeychainErrorType) {
        self.type = type
        
        if let errorMessage = SecCopyErrorMessageString(status, nil) {
            self.message = String(describing: errorMessage)
        } else {
            self.message = "Received status code: \(status)"
        }
        
    }
    
    init(type: KeychainErrorType) {
        self.type = type
    }
    
    init(message: String, type: KeychainErrorType) {
        self.message = message
        self.type = type
    }
    }

