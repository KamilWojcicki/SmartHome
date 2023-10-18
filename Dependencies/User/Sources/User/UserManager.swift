//
//  UserManager.swift
//
//
//  Created by Kamil Wójcicki on 03/10/2023.
//

import AuthenticationInterface
import UserInterface
import SwiftUI
import DependencyInjection

final class UserManager: UserManagerInterface {
    
    private var user: User? {
        didSet {
            
        }
    }
    
    var signInResult: AsyncStream<Bool>
    
    func signInAnonymously() async throws {
        <#code#>
    }
    
    
    @Inject private var authenticationManager: AuthenticationManagerInterface
    
}
