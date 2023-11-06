//
//  MainViewModel.swift
//  
//
//  Created by Kamil Wójcicki on 05/11/2023.
//

import DependencyInjection
import Foundation
import UserInterface

@MainActor
final class MainViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    
    @Published var showSliderInfo: Bool = false
    
    init() {
        checkIsFirstLogin()
    }
    
    private func checkIsFirstLogin() {
        Task {
            do {
                self.showSliderInfo = try await userManager.checkIsFirstLogin()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
