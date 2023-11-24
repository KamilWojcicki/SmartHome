//
//  DeviceInterface.swift
//
//
//  Created by Kamil Wójcicki on 15/11/2023.
//

import Foundation
import CloudDatabaseInterface

public struct Device: Storable, Hashable {
    public let id: String
    public let deviceName: String
    public let state: Bool
    public let symbol: String
    public let turnDeviceOnMessage: String
    public let turnDeviceOffMessage: String
    
    public init(
        id: String = UUID().uuidString,
        deviceName: String,
        state: Bool = false,
        symbol: String,
        turnDeviceOnMessage: String,
        turnDeviceOffMessage: String
    ) {
        self.id = id
        self.deviceName = deviceName
        self.state = state
        self.symbol = symbol
        self.turnDeviceOnMessage = turnDeviceOnMessage
        self.turnDeviceOffMessage = turnDeviceOffMessage
    }
    
    public init(from dao: DeviceDAO) {
        self.id = dao.id
        self.deviceName = dao.deviceName
        self.state = dao.state
        self.symbol = dao.symbol
        self.turnDeviceOnMessage = dao.turnDeviceOnMessage
        self.turnDeviceOffMessage = dao.turnDeviceOffMessage
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case deviceName
        case state
        case symbol
        case turnDeviceOnMessage
        case turnDeviceOffMessage
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
    
    public enum State: String, CaseIterable {
        case off
        case on
        
        public var description: String {
            switch self {
            case .off:
                return "0"
            case .on:
                return "1"
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
    
    public init(from device: Device) {
        self.id = device.id
        self.deviceName = device.deviceName
        self.state = device.state
        self.symbol = device.symbol
        self.turnDeviceOnMessage = device.turnDeviceOnMessage
        self.turnDeviceOffMessage = device.turnDeviceOffMessage
    }
}

public protocol DeviceManagerInterface {
    func readAllUserDevices() async throws -> [Device]
    func updateUserDevice(device: Device, data: [String : Any]) async throws
}

