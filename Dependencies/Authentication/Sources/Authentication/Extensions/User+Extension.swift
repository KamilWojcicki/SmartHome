//
//  User+Extension.swift
//
//
//  Created by Kamil Wójcicki on 05/01/2024.
//

import AuthenticationInterface
import FirebaseAuth
import Foundation

extension FirebaseAuth.User {
    func getProviderID() -> AuthenticationProviderOption? {
        self
            .providerData
            .compactMap { AuthenticationProviderOption(rawValue: $0.providerID) }
            .first
    }
}
