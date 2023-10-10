//
//  LoginView.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import SwiftUI
import Components

public struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject private var launchViewModel: MainLaunchViewModel
    
    public init() { }
    
    public var body: some View {
        VStack(spacing: 20) {
            
            header
            
            logintextFields
                
            recoveryButton
            
            signInButton
            
            textWithLines
                
            socialMediaStack
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    LoginView()
}

extension LoginView {
    
    private var header: some View {
        VStack(spacing: 15) {
            Text("Hello Again!")
                .font(.largeTitle)
                .fontWeight(.bold)
                
            Text("Welcome back you've been missed!")
                .font(.title)
                .multilineTextAlignment(.center)
        }
    }
    
    private var logintextFields: some View {
        VStack(spacing: 20) {
            TextField(textFieldLogin: $viewModel.email, placecholder: "Enter E-mail")
                .textInputAutocapitalization(.none)
            
            SecureField(textFieldPassword: $viewModel.password, placecholder: "Password")
                .textInputAutocapitalization(.none)
        }
        .padding(.top, 20)
    }
    
    private var recoveryButton: some View {
        
        Button {
            viewModel.showSheet.toggle()
        } label: {
            Text("Recovery password")
                .font(.footnote)
                .bold()
                .tint(Color.black)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .sheet(isPresented: $viewModel.showSheet) {
            PasswordRecoveryView(showSheet: $viewModel.showSheet)
                .presentationDetents([.medium])
                .alert(Text("Error"), isPresented: $launchViewModel.showAlert, actions: {
                    
                }, message: {
                    Text(launchViewModel.error?.localizedDescription ?? "")
                })
        }

    }
    
    private var signInButton: some View {
        
        Button {
            Task {
                do {
                    try await viewModel.signIn()
                    print("Login successfully!")
                } catch {
                    self.launchViewModel.error = error
                }
            }
        } label: {
            Text("Sign In!")
                .withMainButtonViewModifier()
        }
        
    }
    
    private var textWithLines: some View {
        HStack {
            CustomLine(startPoint: .leading, endPoint: .trailing)

            Text("Or continue with")
                .font(.footnote)
                .padding(.horizontal)
            
            CustomLine(startPoint: .trailing, endPoint: .leading)
        }
        
    }
    
    private var socialMediaStack: some View {
        HStack {
            
            //SocialMediaButton(type: .google, action: {})
            //SocialMediaButton(type: .apple, action: {})
            //SocialMediaButton(type: .facebook, action: {})
        }
    }
}
