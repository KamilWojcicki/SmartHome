// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import FirebaseCore
import FacebookCore

public final class AppDelegate: NSObject, UIApplicationDelegate {
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    public func application(_ app: UIApplication, open url: URL, options:[UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
        return handled
    }
}
