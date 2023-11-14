//
//  MqttInterface.swift
//  
//
//  Created by Kamil Wójcicki on 11/11/2023.
//

import Foundation
import CocoaMQTT

public enum Message {
    case turnDeviceOn
    case turnDeviceOff
    case addToSchedule(String)
    case deleteFromSchedule(String)
    
    public var description: String {
        switch self {
        case .turnDeviceOn:
            return "2,50,"
        case .turnDeviceOff:
            return "2,51,"
        case .addToSchedule(let date):
            return "1,50,\(date),"
        case .deleteFromSchedule(let date):
            return "1,51,\(date),"
        }
    }
}

public protocol MqttManagerInterface: CocoaMQTTDelegate {
    var isConnected: Bool { get set }
    
    func connect()
    func sendMessage(topic: String, message: String)
    func subscribeToTopic(_ topic: String)
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck)
}
