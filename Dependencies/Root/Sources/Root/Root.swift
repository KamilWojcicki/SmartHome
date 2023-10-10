// The Swift Programming Language
// https://docs.swift.org/swift-book

import Authentication
import DependencyInjection
import Navigation

public struct Dependencies {
    public static func inject() {
        Authentication.Dependencies.inject()
    }
}
