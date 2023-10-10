//
//  MainButtonViewModifiers.swift
//  
//
//  Created by Kamil Wójcicki on 18/09/2023.
//

import SwiftUI

public struct MainButtonViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .frame(height: 65)
            .foregroundColor(.white)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            .background(
                RadialGradient(colors: [Colors.jaffa, Colors.tango], center: .center, startRadius: 10, endRadius: 300)
            )
            .cornerRadius(10)
            .padding(.vertical, 30)
            .shadow(color: Colors.jaffa.opacity(0.3), radius: 20, y: 20)
    }
}

extension View {
    public func withMainButtonViewModifier() -> some View {
        modifier(MainButtonViewModifier())
    }
}
