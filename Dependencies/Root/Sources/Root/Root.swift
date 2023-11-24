// The Swift Programming Language
// https://docs.swift.org/swift-book

import Calendar
import DependencyInjection
import Devices
import Home
import Navigation

public struct Dependencies {
    public static func inject() {
        Navigation.Dependencies.inject()
        Calendar.Dependencies.inject()
        Home.Dependencies.inject()
        Devices.Dependencies.inject()
    }
}
