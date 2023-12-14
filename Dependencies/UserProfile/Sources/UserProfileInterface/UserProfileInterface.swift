//
//  UserProfileInterface.swift
//  
//
//  Created by Kamil Wójcicki on 01/12/2023.
//

import Foundation

public enum ActiveSheet {
    case changeDisplayName
    case changePassword
    case changeMqttKey
    case changeMqttPassword
}

public enum Variant {
    case textfield
    case securefield
}
