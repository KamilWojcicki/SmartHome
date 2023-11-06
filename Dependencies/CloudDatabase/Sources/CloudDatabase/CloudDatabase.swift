// The Swift Programming Language
// https://docs.swift.org/swift-book

import CloudDatabaseInterface
import DependencyInjection

public struct Dependencies {
    public static func inject() {
        Assemblies.inject(type: CloudDatabaseManagerInterface.self, object: CloudDatabaseManager())
    }
}
