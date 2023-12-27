//
//  OnboardingInterface.swift
//  
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import Foundation
import Localizations

public enum ActiveSheet: Identifiable {
    case passwordRecovery
    
    public var id: String {
        switch self {
        case .passwordRecovery:
            UUID().uuidString
        }
    }
}

public enum ValidationError: Error, LocalizedError {
    case emptyField(String)
    case emptyEmail
    case wrongEmail
    case wrongPassword
    case wrongFullname
    case passwordNotMatch
    case passwordIsNotValid
    case emailInUse
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .emptyField(let fieldName):
            return String(format: "empty_field_error".localized, fieldName)
        case .emptyEmail:
            return "empty_email_error".localized
        case .wrongEmail:
            return "wrong_email_error".localized
        case .wrongPassword:
            return "wrong_password_error".localized
        case .wrongFullname:
            return "wrong_fullname_error".localized
        case .passwordNotMatch:
            return "password_not_match_error".localized
        case .passwordIsNotValid:
            return "password_is_not_valid_error".localized
        case .emailInUse:
            return "email_in_use_error".localized
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
