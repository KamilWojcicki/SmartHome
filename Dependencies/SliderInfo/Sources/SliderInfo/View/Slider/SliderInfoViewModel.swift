//
//  SliderInfoViewModel.swift
//
//
//  Created by Kamil Wójcicki on 31/10/2023.
//

import DependencyInjection
import Foundation
import SliderInfoInterface
import SwiftUI
import UserInterface

final class SliderInfoViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    
    @Published var pageIndex = 0
    @Published var topic: String = ""
    
    let pages: [Page] = Page.pages
    
    func incrementPage() {
        pageIndex += 1
    }
    
    func updateUser() async throws {
        let data: [String : Any] = [
            User.CodingKeys.isFirstLogin.rawValue : false,
            User.CodingKeys.topic.rawValue : topic
        ]
        try await userManager.updateUserData(data: data)
    }
    
    
}
