//
//  SheetContent.swift
//
//
//  Created by Kamil Wójcicki on 14/12/2023.
//

import SwiftUI
import Design

public struct SheetContent: View {
    public enum Variant {
        case withField(field: Field, labelButtonText: String, action: () async throws -> Void)
        case onlyText(text: String)
    }
    
    public enum Field {
        case text(textFieldText: Binding<String>, placecholder: String)
        case secure(secureFieldText: Binding<String>, placecholder: String)
    }
    
    private let variant: Variant
    
    public init(variant: Variant) {
        self.variant = variant
    }
    
    public var body: some View {
        buildContent(for: variant)
    }
    
    @ViewBuilder
    private func buildContent(for variant: Variant) -> some View {
        switch variant {
        case .withField(let field, let labelButtonText, let action):
            buildViewWithField(with: field, labelButtonText: labelButtonText, action: action)
        case .onlyText(let text):
            buildViewWithText(text: text)
        }
    }
}
extension SheetContent {
    @ViewBuilder
    private func buildViewWithText(text: String) -> some View {
        ScrollView {
            VStack {
                Text(text)
                    .font(.headline)
            }
        }
    }
    
    @ViewBuilder
    private func buildViewWithField(with field: Field, labelButtonText: String, action: @escaping () async throws -> Void) -> some View {
        Text("Change Display Name")
            .font(.title)
            .multilineTextAlignment(.center)
            .bold()
        
        switch field {
        case .text(let textFieldText, let placecholder):
            TextField(textFieldLogin: textFieldText, placecholder: placecholder)
        case .secure(let secureFieldText, let placecholder):
            SecureField(textFieldPassword: secureFieldText, placecholder: placecholder)
        }
        
        Button {
            Task {
                do {
                    try await action()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } label: {
            Text(labelButtonText)
                .withMainButtonViewModifier()
        }
    }
}
