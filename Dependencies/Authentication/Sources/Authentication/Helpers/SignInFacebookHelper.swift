//
//  SignInFacebookHelper.swift
//  
//
//  Created by Kamil Wójcicki on 07/10/2023.
//

import Foundation
import FBSDKLoginKit

struct FacebookSignInResultModel {
    let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
}

final class SignInFacebookHelper {
    @MainActor
    func signIn() async throws -> FacebookSignInResultModel {

        let manager = LoginManager()
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<FacebookSignInResultModel, Error>) in
            manager.logIn(permissions: ["public_profile", "email"], from: nil) { result, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let result = result, !result.isCancelled {
                    guard let accessToken = AccessToken.current?.tokenString else { return }

                    let signInResult = FacebookSignInResultModel(accessToken: accessToken)
                    continuation.resume(returning: signInResult)
                }
            }
        }
    }
}


