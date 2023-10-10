//
//  Assembly.swift
//  SmartHome
//
//  Created by Kamil Wójcicki on 04/10/2023.
//

import DependencyInjection
import Root

extension Assemblies {
    static func setupDependencies() {
        Root.Dependencies.inject()
    }
}
