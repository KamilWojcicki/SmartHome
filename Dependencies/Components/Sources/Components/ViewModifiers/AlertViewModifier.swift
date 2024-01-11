//
//  AlertViewModifier.swift
//
//
//  Created by Kamil Wójcicki on 04/01/2024.
//

import SwiftUI

struct AlertViewModifier: ViewModifier {
    let errorTitle: String
    @Binding var errorMessageToggle: Bool
    let perform: (() -> Void)?
    
    func body(content: Content) -> some View {
        ZStack {
            content
        }
        .alert(Text(errorTitle), isPresented: $errorMessageToggle) {
            Button("yes_button_tile".localized, role: .destructive) {
                perform?()
            }
            
            Button("no_button_tile".localized, role: .cancel) { }
        }
    }
}

extension View {
    public func withAlert(errorTitle: String, errorMessageToggle: Binding<Bool>, perform: @escaping () -> Void) -> some View {
        modifier(
            AlertViewModifier(
                errorTitle: errorTitle,
                errorMessageToggle: errorMessageToggle,
                perform: perform
            )
        )
    }
}
