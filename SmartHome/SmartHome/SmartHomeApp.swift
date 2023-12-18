//
//  SmartHomeApp.swift
//  SmartHome
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import SwiftUI
import FirebaseSupport
import Root

@main
struct SmartHomeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
