//
//  OnboardingInterface.swift
//  
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import Foundation

public enum ValidationError: Error, LocalizedError {
    case emptyField(String)
    case emptyEmail
    case wrongEmail
    case wrongPassword
    case wrongFullname
    case passwordNotMatch
    case shortPassword
    case emailInUse
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .emptyField(let fieldName):
            return "Field \(fieldName) is empty!" //String(format: "empty_field_error".localized, fieldName)
        case .emptyEmail:
            return "Email field is empty! Please enter an e-mail."
        case .wrongEmail:
            return "There is a problem with e-mail! Check if you enter a valid e-mail."
        case .wrongPassword:
            return "There is a problem with password! Check if you enter a valid password."
        case .wrongFullname:
            return "There is a problem with fullname! Fullname must contains your name and surname separated by a space."
        case .passwordNotMatch:
            return "Passwords do not match! Check if your passwords are the same."
        case .shortPassword:
            return "Password is too short! Passwords needs to be at least 10 characters long."
        case .emailInUse:
            return "Email is already in use! Please enter other valid e-mail."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
