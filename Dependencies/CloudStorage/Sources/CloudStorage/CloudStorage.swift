// The Swift Programming Language
// https://docs.swift.org/swift-book

import CloudStorageInterface
import DependencyInjection

public struct Dependencies {
    public static func inject() {
        Assemblies.inject(type: CloudStorageInterface.self, object: CloudStorageManager())
    }
}
