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
    
    func getUserImage() {
        Task {
            do {
                let user =  try await userManager.fetchUser()
                self.userImage = user.photoURL ?? "person.fill"
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
