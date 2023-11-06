// The Swift Programming Language
// https://docs.swift.org/swift-book


import DependencyInjection
import NavigationInterface
import SwiftUI

public struct Dependencies {
    public static func inject() {
        injectShared()
    }
    
    
    public static func injectShared() {
        Assemblies.resolve(TabCoordinatorInterface.self).register(tab: .calendar)
    }
}

extension Tab {
    public static var calendar: Tab {
        Tab(
            title: "Calendar",
            image: "calendar.circle",
            activeImage: "calendar.circle.fill",
            rootView: AnyView(CalendarView())
        )
    }
}
