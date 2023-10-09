//
//  Provider+Extension.swift
//
//
//  Created by Kamil Wójcicki on 07/10/2023.
//

import Foundation
import FirebaseAuth
import AuthenticationInterface

extension GoogleAuthProvider {
    static func credential(withSignInResult result: GoogleSignInResultModel) -> AuthCredential {
        self.credential(
            withIDToken: result.idToken,
            accessToken: result.accessToken
        )
    }
}

extension FacebookAuthProvider {
    static func credential(withSignInResult result: FacebookSignInResultModel) -> AuthCredential {
        self.credential(withAccessToken: result.accessToken)
    }
}
