// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import DeviceInterface

public struct Dependencies {
    public static func inject() {
        Assemblies.inject(type: DeviceManagerInterface.self, object: DeviceManager())
    }
}
