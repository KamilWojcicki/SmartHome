//
//  UserProfileInterface.swift
//  
//
//  Created by Kamil Wójcicki on 01/12/2023.
//

import Foundation

public enum ActiveSheet: Identifiable {
    case changeDisplayName
    case changePassword
    case changeMqttKey
    case changeMqttPassword
    case reauthenticateUser
    
    public var id: String {
        switch self {
        case .changeDisplayName:
            "changeDisplayName"
        case .changePassword:
            "changePassword"
        case .changeMqttKey:
            "changeMqttKey"
        case .changeMqttPassword:
            "changeMqttPassword"
        case .reauthenticateUser:
            "reauthenticateUser"
        }
    }
}
