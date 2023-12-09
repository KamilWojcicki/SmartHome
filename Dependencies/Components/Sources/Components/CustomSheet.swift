//
//  CustomSheetViewModifier.swift
//
//
//  Created by Kamil Wójcicki on 04/12/2023.
//

import SwiftUI

public struct CustomSheet<Content: View>: View {
    @Binding var showRecoveryView: Bool
    var size: CGSize
    var action: () -> Void
    var content: () -> Content
    
    public init(showRecoveryView: Binding<Bool>, size: CGSize, action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
        self._showRecoveryView = showRecoveryView
        self.size = size
        self.action = action
        self.content = content
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            background
            
            VStack(spacing: 40) {
                VStack {
                    Button {
                        action()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(20)
                
                content()
            }
            .padding(.horizontal)
            .frame(width: size.width, height: size.height * 0.6)
            .background {
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.white)
                    .edgesIgnoringSafeArea(.bottom)
            }
            .offset(y: showRecoveryView ? size.height * 0 : size.height * 1)
        }
    }
}
extension CustomSheet {
    private var background: some View {
        Rectangle()
            .fill(.ultraThinMaterial)
            .ignoresSafeArea()
            .opacity(showRecoveryView ? 1 : 0)
    }
}

#Preview {
    CustomSheet(showRecoveryView: .constant(true), size: .zero, action: {},  content: {})
}
