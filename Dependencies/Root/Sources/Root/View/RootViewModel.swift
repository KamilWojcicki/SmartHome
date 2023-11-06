//
//  File.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import DependencyInjection
import Foundation

@MainActor
final class RootViewModel: ObservableObject {
    @Inject private var authenticationManager: AuthenticationManagerInterface
    
    @Published private(set) var isLogIn: Bool = false
    
    init() {
        getAuthenticatedUser()
    }
    
    func updateUserLoginState() async {
        for try await signInResult in authenticationManager.signInResult {
            self.isLogIn = signInResult
        }
    }
    
    func getAuthenticatedUser() {
        self.isLogIn = ((try? authenticationManager.isUserAuthenticated()) != nil)
    }
}
