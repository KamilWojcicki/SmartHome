// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import WeatherInterface

public struct Dependencies {
    public static func inject() {
        Assemblies.inject(type: WeatherManagerInterface.self, object: WeatherManager())
    }
}
