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
    
    public init(user: User? = nil, signInResult: AsyncStream<Bool>) {
        self.user = user
        self.signInResult = signInResult
    }
    
    func signInAnonymously() async throws {
        
    }
    
    
    @Inject private var authenticationManager: AuthenticationManagerInterface
    
}
