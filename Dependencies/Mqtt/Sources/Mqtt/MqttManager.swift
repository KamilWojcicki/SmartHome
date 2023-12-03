//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 11/11/2023.
//

import CocoaMQTT
import DependencyInjection
import Foundation
import MqttInterface
import UserInterface

final class MqttManager: MqttManagerInterface {
    @Inject private var userManager: UserManagerInterface
    private var mqttClient: CocoaMQTT
    var isConnected: Bool = false
    var receivedMessages: String = ""
    var topic: String = ""
    var password: String = ""
    init() {
        let clientID = "test123"
        let host = "83.6.137.243"
        let port = UInt16(1883)
        self.mqttClient = CocoaMQTT(clientID: clientID, host: host, port: port)
        Task {
            try? await getMqttCredentialFromUser()
        }
        mqttClient.delegate = self
        print("topic from mqttManager: \(String(describing: mqttClient.username))")
        print("password from mqttManager: \(String(describing: mqttClient.password))")
    }
    
    private func getMqttCredentialFromUser() async throws {
        let user = try await userManager.fetchUser()
        mqttClient.username = topic
        mqttClient.password = password
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
        if let messageString = message.string {
                   receivedMessages = messageString
               }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) { 
        if ack == .accept {
            isConnected = true
            subscribeToTopic(topic)
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
