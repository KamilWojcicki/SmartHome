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

struct GoogleSignInResultModel {
    var idToken: String
    var accessToken: String
    
    init(idToken: String, accessToken: String) {
        self.idToken = idToken
        self.accessToken = accessToken
    }
}

final class SignInGoogleHelper {
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = UIApplication.rootViewController else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse) //custom error
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        return GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
    }
}
