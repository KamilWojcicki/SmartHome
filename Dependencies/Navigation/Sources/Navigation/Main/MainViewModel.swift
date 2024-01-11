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
    
    func checkIsFirstLogin() async throws{
        self.showSliderInfo = try await userManager.checkIsFirstLogin()
    }
}
