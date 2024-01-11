//
//  TabBarViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 12/10/2023.
//

import DependencyInjection
import Foundation
import Localizations
import NavigationInterface
import SwiftUI
import UserInterface

@MainActor
final class TabBarViewModel: ObservableObject {
    @Inject private var tabCoordinator: TabCoordinatorInterface
    @Inject private var userManager: UserManagerInterface
    @Published private(set) var tabs: [Tab] = []
    @Published var selectedTab: String?
    @Published var userImage: String = ""
    
    init() {
        self.tabs = tabCoordinator.tabs
        self.selectedTab = "home".localized
    }
    
    func tapped(tab: String) {
        withAnimation {
            self.selectedTab = tab
        }
    }
    
    func getUserImage() async throws {
        let user =  try await userManager.fetchUser()
        self.userImage = user.profileImagePath ?? "person.fill"
    }
    
    func updateUserPhoto() async {
        for await imagePath in userManager.changePhotoResult {
            print("Profile image path updated: \(imagePath)")
            self.userImage = imagePath
        }
    }
}
