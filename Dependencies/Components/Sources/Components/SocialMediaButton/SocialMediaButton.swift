//
//  SocialMediaButton.swift
//
//
//  Created by Kamil Wójcicki on 20/09/2023.
//

import SwiftUI
import Design


public struct SocialMediaButton: View {
    @StateObject private var viewModel = SocialMediaButtonViewModel()
    private var type: viewModel.buttonType
    private var action: () -> Void
    
    private var button: (image: ImageAsset, action: () async throws -> Void, error: error.localizedDescription) {
        switch type {
        case .apple:            return (Icons.appleLogo,         viewModel.signInWithGoogle())
        case .google:           return (Icons.google,            viewModel.signInWithFacebook())
        case .facebook:         return (Icons.facebook,          action)
        }
    }
    
    public init(type: viewModel.buttonType, action: @escaping () -> Void) {
        self.type = type
        self.action = action
    }
    
    public var body: some View {
        Button {
            Task {
                do {
                    try await button.action()
                } catch {
                    print(error)
                }
            }
        } label: {
            Image(asset: button.image)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding()
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Colors.oxfordBlue, lineWidth: 2)
                        .foregroundColor(.black)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.22)
                        .frame(height: 55)
                )
        }
    }
}
#Preview {
    SocialMediaButton(type: .google, action: { })
}
