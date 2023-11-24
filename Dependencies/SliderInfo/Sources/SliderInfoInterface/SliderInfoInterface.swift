//
//  SliderInfoInterface.swift
//
//
//  Created by Kamil Wójcicki on 31/10/2023.
//

import Animation
import Foundation
//import Localizations
import SwiftUI

public struct Page: Identifiable, Equatable {
    public var id = UUID()
    public var name: String
    public var description: String
    public var animation: LottieView
    public var tag: Int
    public var showTopicField: Bool?
    
    public static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.id == rhs.id
    }
    
    public static var samplePage = Page(name: "Test", description: "Test", animation: LottieView(animationConfiguration: .helloWorld, loopMode: .loop), tag: 0)
    
    public static var pages: [Page] = [
        Page(
            name: "Welcome to our App!",
            description: "We are glad to see you, click Next or SLIDE LEFT to enter the TOPIC",
            animation: LottieView(
                animationConfiguration: .helloWorld,
                loopMode: .loop
            ),
            tag: 0
        ),
        Page(
            name: "Enter your device TOPIC",
            description: "TOPIC is required to property use an application. If you enter a non valid Topic you can change it later in settings",
            animation: LottieView(
                animationConfiguration: .topic,
                loopMode: .loop
            ),
            tag: 1,
            showTopicField: true
        ),
        Page(
            name: "Done! 🥳",
            description: "The basic configuration is done! Click Next to launch Main Screen",
            animation: LottieView(
                animationConfiguration: .checkmark,
                loopMode: .playOnce
            ),
            tag: 2
        )
    ]
}
