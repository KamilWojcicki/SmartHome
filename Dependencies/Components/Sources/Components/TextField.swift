//
//  TextField.swift
//  
//
//  Created by Kamil Wójcicki on 18/09/2023.
//

import Design
import SwiftUI

public struct TextField: View {
    
    @Binding private var textFieldLogin: String
    private let placecholder: String
    
    public init(textFieldLogin: Binding<String>, placecholder: String) {
        self._textFieldLogin = textFieldLogin
        self.placecholder = placecholder
    }
    
    public var body: some View {
        SwiftUI.TextField(placecholder, text: $textFieldLogin)
            .frame(height: 65)
            .padding(.horizontal, 25)
            .background(Colors.white.opacity(0.8))
            .cornerRadius(15)
            .shadow(color: Colors.black.opacity(0.4),radius: 5)
            .textInputAutocapitalization(.never)
    }
}
