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
        Assemblies.resolve(TabCoordinatorInterface.self).register(tab: .tasks)
    }
}

extension Tab {
    public static var tasks: Tab {
        Tab(
            title: "Tasks",
            image: "square.and.pencil.circle",
            activeImage: "square.and.pencil.circle.fill",
            rootView: AnyView(TasksView())
        )
    }
}
