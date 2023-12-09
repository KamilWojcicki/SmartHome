//
//  OnboardingInterface.swift
//  
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import Foundation
import Localizations

public enum ActiveSheet {
    case passwordRecovery
}

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
        case .shortPassword:
            return "short_password_error".localized
        case .emailInUse:
            return "email_in_use_error".localized
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}
