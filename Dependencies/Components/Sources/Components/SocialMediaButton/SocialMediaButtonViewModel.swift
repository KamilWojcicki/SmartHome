//
//  SocialMediaButtonViewModel.swift
//
//
//  Created by Kamil Wójcicki on 10/10/2023.
//

import Foundation
import AuthenticationInterface

public final class SocialMediaButtonViewModel: ObservableObject {
    public enum buttonType {
        case apple, google, facebook
    }
    
    @Inject private var authenticationManager: AuthenticationManagerInterface

    public func signInWithGoogle() async throws {
        try await authenticationManager.signInWithGoogle()
    }
    
    public func signInWithFacebook() async throws {
        try await authenticationManager.signInWithFacebook()
    }
}
