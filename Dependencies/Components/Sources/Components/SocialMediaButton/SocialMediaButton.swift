//
//  SocialMediaButton.swift
//
//
//  Created by Kamil Wójcicki on 20/09/2023.
//

import SwiftUI
import Design


public struct SocialMediaButton: View {
    public enum buttonType {
        case apple
        case google
        case facebook
    }
    
    @StateObject private var viewModel = SocialMediaButtonViewModel()
    private var type: buttonType
    
    private var image: ImageAsset {
        switch type {
        case .apple:
            return Icons.appleLogo
        case .google:           
            return Icons.google
        case .facebook:         
            return Icons.facebook
        }
    }
    
    public init(type: buttonType) {
        self.type = type
    }
    
    public var body: some View {
        Button {
            Task {
                do {
                    try await viewModel.buttonTapped(type)
                } catch {
                    print(error)
                }
            }
        } label: {
            Image(asset: image)
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
    SocialMediaButton(type: .google)
}
