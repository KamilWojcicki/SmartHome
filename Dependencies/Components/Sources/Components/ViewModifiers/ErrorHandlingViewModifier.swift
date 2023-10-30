//
//  ErrorHandlingViewModifier.swift
//
//
//  Created by Kamil Wójcicki on 08/10/2023.
//


import SwiftUI

public struct ErrorHandlingViewModifier: ViewModifier {
    @StateObject private var viewModel = ErrorHandlingViewModel()
    
    public func body(content: Content) -> some View {
        ZStack {
            content
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showErrorMessage) { }
    }
}
