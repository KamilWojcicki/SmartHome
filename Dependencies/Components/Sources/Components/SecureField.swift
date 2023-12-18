//
//  SecureField.swift
//
//
//  Created by Kamil Wójcicki on 18/09/2023.
//

import Design
import SwiftUI

public struct SecureField: View {
    
    @Binding private var textFieldPassword: String
    @State private var showPassword: Bool = false
    private let placecholder: String
    
    public init(textFieldPassword: Binding<String>, placecholder: String) {
        self._textFieldPassword = textFieldPassword
        self.placecholder = placecholder
    }
    public var body: some View {
        ZStack {
            SwiftUI.TextField(placecholder, text: $textFieldPassword)
                .opacity(showPassword ? 1 : 0)
            SwiftUI.SecureField(placecholder, text: $textFieldPassword)
                .opacity(showPassword ? 0 : 1)
        }
        
        .frame(height: 65)
        .padding(.horizontal, 25)
        .background(Colors.white.opacity(0.8))
        .cornerRadius(15)
        .shadow(color: Colors.black.opacity(0.4),radius: 5)
        .textInputAutocapitalization(.never)
        .overlay {
            Image(systemName:  showPassword ? "eye" : "eye.slash")
                .foregroundColor(Color.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 15)
                .onTapGesture {
                    withAnimation {
                        showPassword.toggle()
                    }
                }
        }
    }
}
