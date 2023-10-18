//
//  MeasureSizeModifier.swift
//  
//
//  Created by Kamil Wójcicki on 12/10/2023.
//

import SwiftUI

internal struct MeasureSizeModifier: ViewModifier {
    private let callback: (CGSize) -> Void
    
    internal init(callback: @escaping (CGSize) -> Void) {
        self.callback = callback
    }
    
    internal func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { reader in
                    Color.clear
                        .onAppear {
                            callback(reader.size)
                        }
                }
            }
    }
}

extension View {
    public func measureSize(_ callback: @escaping (CGSize) -> Void) -> some View {
        self.modifier(MeasureSizeModifier(callback: callback))
    }
}
