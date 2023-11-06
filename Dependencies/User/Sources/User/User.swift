// The Swift Programming Language
// https://docs.swift.org/swift-book

import Authentication
import CloudDatabase
import DependencyInjection
import UserInterface

public struct Dependencies {
    public static func inject() {
        Assemblies.inject(type: UserManagerInterface.self, object: UserManager())
        
        Authentication.Dependencies.inject()
        CloudDatabase.Dependencies.inject()
    }
}
