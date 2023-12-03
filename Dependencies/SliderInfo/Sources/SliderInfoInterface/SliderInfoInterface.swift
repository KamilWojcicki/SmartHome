//
//  SliderInfoInterface.swift
//
//
//  Created by Kamil Wójcicki on 31/10/2023.
//

import Animation
import Foundation
import Localizations
import SwiftUI

public struct Page: Identifiable, Equatable {
    public var id = UUID()
    public var name: String
    public var description: String
    public var animation: LottieView
    public var tag: Int
    public var showTopicField: Bool?
    public var showDeviceList: Bool?
    
    public static func == (lhs: Page, rhs: Page) -> Bool {
        lhs.id == rhs.id
    }
    
    public static var samplePage = Page(name: "Test", description: "Test", animation: LottieView(animationConfiguration: .helloWorld, loopMode: .loop), tag: 0)
    
    public static var pages: [Page] = [
        Page(
            name: "first_page_title".localized,
            description: "first_page_description".localized,
            animation: LottieView(
                animationConfiguration: .helloWorld,
                loopMode: .loop
            ),
            tag: 0
        ),
        Page(
            name: "second_page_title".localized,
            description: "second_page_description".localized,
            animation: LottieView(
                animationConfiguration: .topic,
                loopMode: .loop
            ),
            tag: 1,
            showTopicField: true
        ),
        Page(
            name: "third_page_title".localized,
            description: "third_page_description".localized,
            animation: LottieView(
                animationConfiguration: .fingerPick,
                loopMode: .loop
            ),
            tag: 2,
            showDeviceList: true
        ),
        Page(
            name: "fourth_page_title".localized,
            description: "fourth_page_description".localized,
            animation: LottieView(
                animationConfiguration: .checkmark,
                loopMode: .playOnce
            ),
            tag: 3
        )
    ]
}
