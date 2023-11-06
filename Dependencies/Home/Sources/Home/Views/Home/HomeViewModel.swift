//
//  HomeViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import DependencyInjection
import Foundation
import UserInterface

@MainActor
final class HomeViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    @Published private(set) var displayName: String = ""
    
    init() {
        getDisplayName()
    }
    
    func getDisplayName() {
        Task {
            do {
                let user = try await userManager.fetchUser()
                self.displayName = user.displayName ?? "Unknown"
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
