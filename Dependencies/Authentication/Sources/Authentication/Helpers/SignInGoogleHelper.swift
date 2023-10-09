//
//  SignInGoogleHelper.swift
//
//
//  Created by Kamil Wójcicki on 07/10/2023.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import Utilities

public struct GoogleSignInResultModel {
    public var idToken: String
    public var accessToken: String
    
    public init(idToken: String, accessToken: String) {
        self.idToken = idToken
        self.accessToken = accessToken
    }
}

public final class SignInGoogleHelper {
    
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = UIApplication.rootViewController else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        return GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
    }
}
