// The Swift Programming Language
// https://docs.swift.org/swift-book

import CloudDatabase
import DependencyInjection
import ToDoInterface

public struct Dependencies {
    public static func inject() {
        Assemblies.inject(type: ToDoManagerInterface.self, object: ToDoManager())
        
        CloudDatabase.Dependencies.inject()
    }
}
