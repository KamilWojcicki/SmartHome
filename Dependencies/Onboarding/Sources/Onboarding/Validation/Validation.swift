//
//  Validation.swift
//  
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import OnboardingInterface

public struct Validation {
    static func validateField(_ fieldValue: String, fieldName: String) throws {
        guard !fieldValue.isEmpty else {
            throw ValidationError.emptyField(fieldName)
        }
    }
    
    static func validatePassword(password: String, confirmPassword: String) throws {
        guard isPasswordValid(password) else {
            throw ValidationError.wrongPassword
        }
        
        guard (password == confirmPassword) else {
            throw ValidationError.passwordNotMatch
        }
    }
    
    static private func isPasswordValid(_ password: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return passwordTest.evaluate(with: password)
    }
}
