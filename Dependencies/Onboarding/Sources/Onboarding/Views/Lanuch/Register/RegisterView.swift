//
//  RegisterView.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import SwiftUI
import Components

struct RegisterView: View {
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject private var launchViewModel: MainLaunchViewModel
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                header
                
                registerTextFields
                
                signUpButton
                
                Spacer()
            }
            .padding(.horizontal, 30)
        }
    }
}

#Preview {
    RegisterView()
}

extension RegisterView {
    
    private var header: some View {
        VStack(spacing: 15) {
            Text("Not a member?")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Register now and HAVE FUN!")
                .font(.title)
                .multilineTextAlignment(.center)
            
            
        }
    }
    
    private var registerTextFields: some View {
        VStack(spacing: 20) {
            TextField(textFieldLogin: $viewModel.email, placecholder: "Enter new E-mail")
            
            TextField(textFieldLogin: $viewModel.fullname, placecholder: "Enter your full name")
            
            SecureField(textFieldPassword: $viewModel.password, placecholder: "Enter Password")
            
            SecureField(textFieldPassword: $viewModel.confirmPassword, placecholder: "Confirm Password")
        }
        .padding(.top, 20)
    }
    
    private var signUpButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.signUp()
                    print("User added successfully!")
                } catch {
                    self.launchViewModel.error = error
                }
            }
        } label: {
            Text("Sign Up!")
                .withMainButtonViewModifier()
        }
    }
}
