//
//  DeviceInterface.swift
//
//
//  Created by Kamil Wójcicki on 15/11/2023.
//

import CloudDatabaseInterface
import Foundation
import Localizations

public struct Device: Storable, Hashable {
    public let id: String
    public let deviceName: String
    public let state: Bool
    public let symbol: String
    public let turnDeviceOnMessage: String
    public let turnDeviceOffMessage: String
    public let isDeviceAdd: Bool
    public let pin: Int
    
    public init(
        id: String = UUID().uuidString,
        deviceName: String,
        state: Bool = false,
        symbol: String,
        turnDeviceOnMessage: String,
        turnDeviceOffMessage: String,
        isDeviceAdd: Bool = false,
        pin: Int
    ) {
        self.id = id
        self.deviceName = deviceName
        self.state = state
        self.symbol = symbol
        self.turnDeviceOnMessage = turnDeviceOnMessage
        self.turnDeviceOffMessage = turnDeviceOffMessage
        self.isDeviceAdd = isDeviceAdd
        self.pin = pin
    }
    
    public init(from dao: DeviceDAO) {
        self.id = dao.id
        self.deviceName = dao.deviceName
        self.state = dao.state
        self.symbol = dao.symbol
        self.turnDeviceOnMessage = dao.turnDeviceOnMessage
        self.turnDeviceOffMessage = dao.turnDeviceOffMessage
        self.isDeviceAdd = dao.isDeviceAdd
        self.pin = dao.pin
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case deviceName
        case state
        case symbol
        case turnDeviceOnMessage
        case turnDeviceOffMessage
        case isDeviceAdd
        case pin
    }
    
    public enum State: String, CaseIterable {
        case off
        case on
        
        public var description: String {
            switch self {
            case .off:
                "off".localized
            case .on:
                "on".localized
            }
        }
        
        public var state: String {
            switch self {
            case .off:
                "0"
            case .on:
                "1"
            }
        }
    }
    
    public enum Devices: String, CaseIterable {
        case light
        case sprinkler
        case heater
        case garage
        case fan
        
        public var description: String {
            switch self {
            case .light:
                "light".localized
            case .sprinkler:
                "sprinkler".localized
            case .heater:
                "heater".localized
            case .garage:
                "garage".localized
            case .fan:
                "fan".localized
            }
        }
        
        public var symbol: String {
            switch self {
            case .light:
                "lightbulb.fill"
            case .sprinkler:
                "sprinkler.and.droplets.fill"
            case .heater:
                "heater.vertical.fill"
            case .garage:
                "door.garage.closed"
            case .fan:
                "fanblades.fill"
            }
        }
        
        public var turnOnDeviceMessage: String {
            switch self {
            case .light:
                "2,20,"
            case .sprinkler:
                "2,30,"
            case .heater:
                "2,40,"
            case .garage:
                "2,50,"
            case .fan:
                "2,60,"
            }
        }
        
        public var turnOffDeviceMessage: String {
            switch self {
            case .light:
                "2,21,"
            case .sprinkler:
                "2,31,"
            case .heater:
                "2,41,"
            case .garage:
                "2,51,"
            case .fan:
                "2,61,"
            }
        }
        
        public var addToScheduleMessage: (String) -> String {
            switch self {
            case .light:
                return { time in
                    "1,20,\(time),"
                }
            case .sprinkler:
                return { time in
                    "1,30,\(time),"
                }
            case .heater:
                return { time in
                    "1,40,\(time),"
                }
            case .garage:
                return { time in
                    "1,50,\(time),"
                }
            case .fan:
                return { time in
                    "1,60,\(time),"
                }
            }
        }
        
        public var deleteFromScheduleMessage: (String) -> String {
            switch self {
            case .light:
                return { time in
                    "1,21,\(time),"
                }
            case .sprinkler:
                return { time in
                    "1,31,\(time),"
                }
            case .heater:
                return { time in
                    "1,41,\(time),"
                }
            case .garage:
                return { time in
                    "1,51,\(time),"
                }
            case .fan:
                return { time in
                    "1,61,\(time),"
                }
            }
        }
    }
}

public struct DeviceDAO: DAOInterface {
    public static var collection: String = "Devices"
    
    public var docRef: String?
    
    public let id: String
    public let deviceName: String
    public let state: Bool
    public let symbol: String
    public let turnDeviceOnMessage: String
    public let turnDeviceOffMessage: String
    public let isDeviceAdd: Bool
    public let pin: Int
    
    public init(from device: Device) {
        self.id = device.id
        self.deviceName = device.deviceName
        self.state = device.state
        self.symbol = device.symbol
        self.turnDeviceOnMessage = device.turnDeviceOnMessage
        self.turnDeviceOffMessage = device.turnDeviceOffMessage
        self.isDeviceAdd = device.isDeviceAdd
        self.pin = device.pin
    }
}

public protocol DeviceManagerInterface {
    func readAllDevices() async throws -> [Device]
}

