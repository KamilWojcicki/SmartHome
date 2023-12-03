//
//  MqttInterface.swift
//  
//
//  Created by Kamil Wójcicki on 11/11/2023.
//

import Foundation
import CocoaMQTT

public protocol MqttManagerInterface: CocoaMQTTDelegate {
    var isConnected: Bool { get set }
    var receivedMessages: String { get }
    var topic: String { get set }
    var password: String { get set }
    func connect()
    func sendMessage(topic: String, message: String)
    func subscribeToTopic(_ topic: String)
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck)
}
