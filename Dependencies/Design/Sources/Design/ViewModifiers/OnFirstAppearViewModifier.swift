//
//  OnFirstAppearViewModifier.swift
//
//
//  Created by Kamil Wójcicki on 03/01/2024.
//

import Foundation
import SwiftUI

struct OnFirstAppearViewModifier: ViewModifier {
    @State private var didAppear: Bool = false
    let perform: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if !didAppear {
                    perform?()
                    didAppear = true
                }
            }
    }
}

extension View {
    public func onFirstAppear(perform: (() -> Void)?) -> some View {
        self.modifier(OnFirstAppearViewModifier(perform: perform))
    }
}
