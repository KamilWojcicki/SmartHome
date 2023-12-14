// The Swift Programming Language
// https://docs.swift.org/swift-book

import CloudStorage
import DependencyInjection

public struct Dependencies {
    public static func inject() {
        CloudStorage.Dependencies.inject()
    }
}
