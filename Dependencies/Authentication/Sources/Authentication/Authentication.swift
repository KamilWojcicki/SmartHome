// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import AuthenticationInterface

public struct Dependencies {
    public static func inject() {
        Assemblies.inject(
            type: AuthenticationManagerInterface.self,
            object: AuthenticationManager()
        )
    }
}
