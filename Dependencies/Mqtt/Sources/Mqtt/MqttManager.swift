//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 11/11/2023.
//

import CocoaMQTT
import Foundation
import MqttInterface

final class MqttManager: MqttManagerInterface {
    
    private var mqttClient: CocoaMQTT
    var isConnected: Bool = false
    var receivedMessages: [String : String] = [:]
    
    init() {
        let clientID = "test123"
        let host = "83.6.151.29"
        let port = UInt16(1883)
        self.mqttClient = CocoaMQTT(clientID: clientID, host: host, port: port)
        self.mqttClient.username = "1234"
        self.mqttClient.password = "essa"
        self.mqttClient.delegate = self
    }
    
    func connect() {
       _ = self.mqttClient.connect()
        
        if isConnected {
            print("Mqtt is connected")
        } else {
            print("Problem with connection")
        }
    }
    
    func sendMessage(topic: String, message: String) {
        self.mqttClient.publish(topic, withString: message, qos: .qos1)
    }
    
    func subscribeToTopic(_ topic: String) {
        self.mqttClient.subscribe(topic)
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        if let stringData = message.string {
            DispatchQueue.main.async {
                self.receivedMessages[message.topic] = stringData
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) { 
        if ack == .accept {
            isConnected = true
            subscribeToTopic("1234")
        } else {
            isConnected = false
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) { }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) { }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) { }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) { }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) { }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) { }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) { }
}
