//
//  TextStyleViewModifier.swift
//  
//
//  Created by Kamil Wójcicki on 27/09/2023.
//

//import Foundation
import SwiftUI

struct TextStyleViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(Colors.jaffa)
    }
}

extension View {
    func withTextStyleViewModifier() -> some View {
        modifier(TextStyleViewModifier())
    }
}
