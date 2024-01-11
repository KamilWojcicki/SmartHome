//
//  ErrorHandlingViewModifier.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//


import SwiftUI

struct ErrorHandlingViewModifier: ViewModifier {
    let errorMessage: String
    @Binding var errorMessageToggle: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
        }
        .alert(Text("error_title".localized), isPresented: $errorMessageToggle) { } message: {
            Text(errorMessage)
        }
    }
}

extension View {
    public func withErrorHandler(errorMessage: String, errorMessageToggle: Binding<Bool>) -> some View {
        modifier(
            ErrorHandlingViewModifier(
                errorMessage: errorMessage,
                errorMessageToggle: errorMessageToggle
            )
        )
    }
}
