//
//  SettingsInterface.swift
//  
//
//  Created by Kamil Wójcicki on 22/10/2023.
//

import Foundation
import Localizations

public enum ActiveSheet: Identifiable {
    case privacyPolicy
    case termsAndConditions
    case ourTeam
    
    public var id: String {
        switch self {
        case .privacyPolicy:
            "privacyPolicy"
        case .termsAndConditions:
            "termsAndConditions"
        case .ourTeam:
            "ourTeam"
        }
    }
    
    public var description: String {
        switch self {
        case .privacyPolicy:
            return "privacy_policy".localized
        case .termsAndConditions:
            return "terms_of_use".localized
        case .ourTeam:
            return ""
        }
    }
}

