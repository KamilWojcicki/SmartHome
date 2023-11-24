//
//  Row.swift
//  
//
//  Created by Kamil Wójcicki on 18/09/2023.
//

import SwiftUI
import Design

public struct Row: View {
    
    public enum Variant {
        case plainText(text: String, action: () -> Void)
        case toggle(text: String, binding: Binding<Bool>)
    }
    
    private let symbol: String
    private let variant: Variant
    
   public init(symbol: String, variant: Variant) {
        self.symbol = symbol
        self.variant = variant
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: symbol)
                .foregroundColor(Colors.white)
                .font(.title2)
            
            buildRowView(for: variant)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Colors.oxfordBlue)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    @ViewBuilder
    private func buildRowView(for variant: Variant) -> some View {
        switch variant {
        case .plainText(let text, let action):
            buildText(text)
                .onTapGesture(perform: action)
        case .toggle(let text, let binding):
            Toggle(isOn: binding) {
                buildText(text)
            }
            .tint(Colors.jaffa)
        }
    }
    
    private func buildText(_ text: String) -> some View {
        Text(text)
            .font(.title2)
            .foregroundColor(Colors.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct Row_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack(spacing: 15) {
            Row(symbol: "moon.stars", variant: .plainText(text: "test", action: {}))
            
            Row(symbol: "moon.stars", variant: .toggle(text: "test", binding: .constant(true)))
        }
    }
}
