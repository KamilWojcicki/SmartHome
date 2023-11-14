//
//  CalendarInterface.swift
//  
//
//  Created by Kamil Wójcicki on 13/10/2023.
//

import Foundation

public enum Action: String, CaseIterable {
    case light
    case sprinkler
    case heater
    case garage
    case fan
    
    public var description: String {
        switch self {
        case .light:
            return "lightbulb.fill"
        case .sprinkler:
            return "sprinkler.and.droplets.fill"
        case .heater:
            return "heater.vertical.fill"
        case .garage:
            return "door.garage.closed"
        case .fan:
            return "fanblades.fill"
        }
    }
}
