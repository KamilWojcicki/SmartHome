//
//  SocialMediaButtonViewModel.swift
//
//
//  Created by Kamil Wójcicki on 10/10/2023.
//

import Foundation
import DependencyInjection
import AuthenticationInterface



public final class SocialMediaButtonViewModel: ObservableObject {
    
    
    @Inject private var authenticationManager: AuthenticationManagerInterface

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
        try await authenticationManager.signInWithGoogle()
    }
    
    private func signInWithFacebook() async throws {
        try await authenticationManager.signInWithFacebook()
    }
    #warning("method didn't finished yet")
    private func signInWithApple() async throws {
        
    }
}
