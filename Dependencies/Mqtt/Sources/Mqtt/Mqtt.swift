// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import MqttInterface

public struct Dependencies {
    public static func inject() {
        Assemblies.inject(type: MqttManagerInterface.self, object: MqttManager())
    }
}
