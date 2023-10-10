//
//  AssemblyShared.swift
//  SmartHome
//
//  Created by Kamil Wójcicki on 04/10/2023.
//

import DependencyInjection
import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc internal class func setup() {
        Assemblies.setupDependencies()
    }
}
