//
//  SheetContent.swift
//
//
//  Created by Kamil Wójcicki on 14/12/2023.
//

import SwiftUI
import Design
import Utilities

public struct SheetContent: View {
    public enum Variant {
        case withField(field: Field, text: String, labelButtonText: String, action: () -> Void)
        case onlyText(text: String)
        case withFields(fields: [Field], text: String, labelButtonText: String, action: () -> Void)
    }
    
    public enum Field: Hashable {
        var identifier: String {
                return UUID().uuidString
            }
        public static func == (lhs: SheetContent.Field, rhs: SheetContent.Field) -> Bool {
            return lhs.identifier == rhs.identifier
        }
        
        public func hash(into hasher: inout Hasher) {
            return hasher.combine(identifier)
        }
        
        case text(textFieldText: Binding<String>, placecholder: String)
        case secure(secureFieldText: Binding<String>, placecholder: String)
    }
    
    private let variant: Variant
    private let action: () -> Void
    
    public init(variant: Variant, action: @escaping () -> Void) {
        self.variant = variant
        self.action = action
    }
    
    public var body: some View {
        buildContent(for: variant)
            .presentationDetents([.medium])
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                Image(systemName: "xmark")
                    .foregroundStyle(Colors.jaffa)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(15)
                    .onTapGesture {
                        action()
                    }
            }
    }
    
    @ViewBuilder
    private func buildContent(for variant: Variant) -> some View {
        switch variant {
        case .withField(let field, let text, let labelButtonText, let action):
            buildViewWithField(with: field, text: text, labelButtonText: labelButtonText, action: action)
        case .onlyText(let text):
            buildViewWithText(text: text)
        case .withFields(fields: let fields, text: let text, labelButtonText: let labelButtonText, action: let action):
            buildViewWithFields(with: fields, text: text, labelButtonText: labelButtonText, action: action)
        }
    }
}
extension SheetContent {
    @ViewBuilder
    private func buildViewWithText(text: String) -> some View {
        ScrollView {
            Text(text)
                .font(.headline)
                .foregroundStyle(Colors.black)
                .padding()
                .padding(.trailing, 15)
        }
    }
    
    @ViewBuilder
    private func buildViewWithFields(with fields: [Field], text: String, labelButtonText: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 30) {
            Text(text)
                .font(.title)
                .foregroundStyle(Colors.black)
                .multilineTextAlignment(.center)
                .bold()
                .padding(.vertical)
            
            ForEach(fields, id: \.self) { field in
                switch field {
                case .text(let textFieldText, let placecholder):
                    TextField(textFieldLogin: textFieldText, placecholder: placecholder)
                case .secure(let secureFieldText, let placecholder):
                    SecureField(textFieldPassword: secureFieldText, placecholder: placecholder)
                }
            }
            
            
            Button {
               action()
            } label: {
                Text(labelButtonText)
                    .withMainButtonViewModifier()
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private func buildViewWithField(with field: Field, text: String, labelButtonText: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 30) {
            Text(text)
                .font(.title)
                .foregroundStyle(Colors.black)
                .multilineTextAlignment(.center)
                .bold()
                .padding(.bottom)
            
            switch field {
            case .text(let textFieldText, let placecholder):
                TextField(textFieldLogin: textFieldText, placecholder: placecholder)
            case .secure(let secureFieldText, let placecholder):
                SecureField(textFieldPassword: secureFieldText, placecholder: placecholder)
            }
            
            Button {
               action()
            } label: {
                Text(labelButtonText)
                    .withMainButtonViewModifier()
            }
        }
        .padding(.horizontal)
    }
}
