// The Swift Programming Language
// https://docs.swift.org/swift-book

import DependencyInjection
import Localizations
import Mqtt
import NavigationInterface
import SwiftUI
import Weather

public struct Dependencies {
    public static func inject() {
        injectShared()
        Mqtt.Dependencies.inject()
        Weather.Dependencies.inject()
    }
    
    public static func injectShared() {
        Assemblies.resolve(TabCoordinatorInterface.self).register(tab: .home)
    }
}

extension Tab {
    public static var home: Tab {
        return Tab(
            title: "home".localized,
            image: "house",
            activeImage: "house.fill",
            rootView: AnyView(HomeView())
        )
    }
}
