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
    @Published private(set) var isFirstLogin: Bool = {
        UserDefaults.standard.bool(forKey: "isFristLogin")
    }()
    
    init() {
        checkIsFirstLogin()
        handleSignIn()
        print("user default",isFirstLogin.description)
    }
    
    func updateUserLoginState() async {
        for try await signInResult in userManager.signInResult {
            self.isLogIn = signInResult
        }
    }
    
    private func handleSignIn() {
        do {
            self.isLogIn = try userManager.isUserAuthenticated()
        } catch {
            print(error)
        }
    }

    func checkIsFirstLogin() {
        Task {
            do {
                self.isFirstLogin = try await userManager.checkIsFirstLogin()
                print(isFirstLogin)
            } catch {
                print(error)
            }
        }
    }
}
