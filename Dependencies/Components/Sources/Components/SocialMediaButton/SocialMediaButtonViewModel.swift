//
//  SocialMediaButtonViewModel.swift
//
//
//  Created by Kamil Wójcicki on 10/10/2023.
//

import DependencyInjection
import Foundation
import UserInterface

public final class SocialMediaButtonViewModel: ObservableObject {
    @Inject private var userManager: UserManagerInterface

    @Published var error: Error?
    
    public func buttonTapped(_ type: SocialMediaButton.buttonType) async throws {
        switch type {
        case .apple:
            try await signInWithApple()
        case .google:
            try await signInWithGoogle()
        case .facebook:
            try await signInWithFacebook()
        }
    }
    
    private func signInWithGoogle() async throws {
        let _ = try await userManager.signInWithGoogle()
    }
    
    private func signInWithFacebook() async throws {
        let _ = try await userManager.signInWithFacebook()
    }
    
    private func signInWithApple() async throws {
        let _ = try await userManager.signInWithApple()
    }
}
