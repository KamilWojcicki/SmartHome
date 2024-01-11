//
//  Validation.swift
//  
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import Foundation
import Localizations
import OnboardingInterface

struct Validation {
    static func validateField(_ fieldValue: String, fieldName: String) throws {
        guard !fieldValue.isEmpty else {
            throw ValidationError.emptyField(fieldName)
        }
        
        if fieldName == "field_name_password".localized {
            guard isPasswordValid(fieldValue) else {
                throw ValidationError.passwordIsNotValid
            }
        }
    }
    
    static func validateEmail(email: String) throws {
        guard isEmailValid(email) else {
            throw ValidationError.wrongEmail
        }
    }
    
    static func validatePassword(password: String, confirmPassword: String) throws {
        guard isPasswordValid(password) else {
            throw ValidationError.passwordIsNotValid
        }
        
        guard (password == confirmPassword) else {
            throw ValidationError.passwordNotMatch
        }
    }
    
    static func validateFullname(fullname: String) throws {
        guard isFullnameValid(fullname) else {
            throw ValidationError.wrongFullname
        }
    }
    
    static private func isEmailValid(_ email: String) -> Bool {
        let regex = "^([a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,})$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return emailTest.evaluate(with: email)
    }
    
    static private func isPasswordValid(_ password: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return passwordTest.evaluate(with: password)
    }
    
    static private func isFullnameValid(_ fullname: String) -> Bool {
        let regex = "^[A-ZĄĆĘŁŃÓŚŹŻ][a-ząćęłńóśźż]{1,}(?: [A-ZĄĆĘŁŃÓŚŹŻ][a-ząćęłńóśźż]{2,}){0,2}$"
        let fullnameTest = NSPredicate(format: "SELF MATCHES %@", regex)
        return fullnameTest.evaluate(with: fullname)
    }
}
