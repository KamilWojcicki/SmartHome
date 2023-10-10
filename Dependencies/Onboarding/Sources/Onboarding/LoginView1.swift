//
//  LoginView.swift
//
//
//  Created by Kamil Wójcicki on 04/10/2023.
//

import SwiftUI
import DependencyInjection
import AuthenticationInterface

final class LoginViewModel1: ObservableObject {
    @Inject private var authenticationManager: AuthenticationManagerInterface
    
    public func logInByAnonymous() async throws {
        try await signInAnonymously()
    }
    
    private func signInAnonymously() async throws {
        try await authenticationManager.signInAnonymously()
    }
    
}

public struct LoginView1: View {
    
    @StateObject private var viewModel = LoginViewModel1()
    
    public init() { }
    
    public var body: some View {
        VStack {
            Text("Login In View")
            
            Button {
                Task {
                    do {
                        try await viewModel.logInByAnonymous()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Sign In Anonymously")
                    .padding()
                    .background(Color.blue)
                    .tint(Color.white)
                    .clipShape(.rect(cornerRadius: 20))
            }
            
        }
        
        
    }
}

#Preview {
    LoginView1()
}
