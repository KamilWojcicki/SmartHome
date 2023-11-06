//
//  TabBarViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 12/10/2023.
//

import DependencyInjection
import Foundation
import NavigationInterface
import SwiftUI


final class TabBarViewModel: ObservableObject {
    @Inject private var tabCoordinator: TabCoordinatorInterface
    
    @Published private(set) var tabs: [Tab] = []
    @Published var selectedTab: String?
    
    init() {
        self.tabs = tabCoordinator.tabs
        self.selectedTab = "home"
    }
    
    func tapped(tab: String) {
        withAnimation {
            self.selectedTab = tab
        }
    }
}
