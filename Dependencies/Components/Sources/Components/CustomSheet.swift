//
//  CustomSheetViewModifier.swift
//
//
//  Created by Kamil Wójcicki on 04/12/2023.
//

import SwiftUI
import Design

public struct CustomSheet<Item: Hashable, Content: View>: View {
    private let size: CGSize
    private var item: Binding<Item?>
    private var content: (Item) -> Content
    
    public init(
        size: CGSize,
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.size = size
        self.item = item
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            background
            
            VStack(spacing: 30) {
                VStack {
                    Button {
                        withAnimation {
                            item.wrappedValue = nil
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .tint(Colors.jaffa)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .frame(height: 10)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                if let item = item.wrappedValue {
                    content(item)
                }
            }
            .padding(.horizontal)
            .frame(width: size.width, height: size.height * 0.6)
            .background {
                RoundedRectangle(cornerRadius: 50)
                    .fill(Colors.white)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .offset(y: (item.wrappedValue != nil) ? size.height * 0 : size.height * 1)
        }
    }
}
extension CustomSheet {
    private var background: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
            .opacity((item.wrappedValue != nil) ? 1 : 0)
    }
}

