//
//  LoginView.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//

import SwiftUI
import Components
import Localizations

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject private var launchViewModel: MainLaunchViewModel
    
    var body: some View {
        ZStack {
            
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
            .ignoresSafeArea(.keyboard)
        }
    }
}

#Preview {
    LoginView()
}

extension LoginView {
    
    private var header: some View {
        VStack(spacing: 15) {
            Text("login".localized)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("login_hello_subtitle".localized)
                .font(.title)
                .multilineTextAlignment(.center)
        }
    }
    
    private var logintextFields: some View {
        VStack(spacing: 20) {
            TextField(textFieldLogin: $viewModel.email, placecholder: "email_textfield".localized)
                .textInputAutocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField(textFieldPassword: $viewModel.password, placecholder: "password_textfield".localized)
                .textInputAutocapitalization(.none)
                .keyboardType(.default)
                
        }
        .padding(.top, 20)
    }
    
    private var recoveryButton: some View {
        Text("recovery_password_button".localized)
            .font(.footnote)
            .bold()
            .tint(Color.primary)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .onTapGesture {
                launchViewModel.showRecoveryView(activeSheet: .passwordRecovery)
            }
    }
    
    private var signInButton: some View {
        Text("sign_in_button_title".localized)
            .withMainButtonViewModifier()
            .onTapGesture {
                Task {
                    do {
                        try await viewModel.signIn()
                        print("Login successfully!")
                    } catch {
                        self.launchViewModel.handleError(error)
                    }
                }
            }
    }
    
    private var textWithLines: some View {
        HStack {
            CustomLine(startPoint: .leading, endPoint: .trailing)
            
            Text("onboarding_continue_with".localized)
                .font(.footnote)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            
            CustomLine(startPoint: .trailing, endPoint: .leading)
        }
        
    }
    
    private var socialMediaStack: some View {
        HStack {
            SocialMediaButton(type: .google)
            SocialMediaButton(type: .apple)
            SocialMediaButton(type: .facebook)
        }
    }
}
