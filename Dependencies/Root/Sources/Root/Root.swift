// The Swift Programming Language
// https://docs.swift.org/swift-book

import Calendar
import DependencyInjection
import Home
import Navigation
import Tasks

public struct Dependencies {
    public static func inject() {
        Navigation.Dependencies.inject()
        Calendar.Dependencies.inject()
        Home.Dependencies.inject()
        Tasks.Dependencies.inject()
    }
}
