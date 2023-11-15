// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import NavigationInterface
import SwiftUI

public struct Dependencies {
    public static func inject() {
        
    }
    
    public static func injectShared() {
        Assemblies.resolve(TabCoordinatorInterface.self).register(tab: .devices)
    }
}

extension Tab {
    public static var devices: Tab {
        Tab(
            title: "Devices",
            image: "tv.circle",
            activeImage: "tv.circle.fill",
            rootView: AnyView(DeviceView())
        )
    }
}
