//
//  File.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import DependencyInjection
import Foundation
import UserInterface

@MainActor
final class RootViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface
    
    @Published private(set) var isLogIn: Bool = false
    
    init() {
        getAuthenticatedUser()
    }
    
    func updateUserLoginState() async {
        for try await signInResult in userManager.signInResult {
            self.isLogIn = signInResult
        }
    }
    
    func getAuthenticatedUser() {
        self.isLogIn = ((try? userManager.isUserAuthenticated()) != nil)
    }
}
