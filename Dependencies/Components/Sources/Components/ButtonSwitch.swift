//
//  ButtonSwitch.swift
//  SmartHomeApp
//
//  Created by Kamil Wójcicki on 06/07/2023.
//

import SwiftUI
import Design

public struct ButtonSwitch: View {
    @Binding private var switchButton: Bool
    @State private var transition: Bool = false
    
    public init(switchButton: Binding<Bool>) {
        self._switchButton = switchButton
    }
    public var body: some View {
        GeometryReader { geometry in
            HStack {
                Button {
                    switchButton = false
                    transition = true
                } label: {
                    Text("Register")
                        .foregroundColor(switchButton ? .black : .white)
                        .font(.headline)
                }
                .frame(width: geometry.size.width / 2)
                Button {
                    switchButton = true
                    transition = false
                } label: {
                    Text("Sign In")
                        .foregroundColor(switchButton ? .white : .black)
                        .font(.headline)
                }
                .frame(width: geometry.size.width / 2)
            }
            .frame(height: 65)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Colors.oxfordBlue, lineWidth: 2)
                    .overlay (
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Colors.oxfordBlue)
                            .frame(width: geometry.size.width / 2),
                        alignment: transition ? .leading : .trailing
                    )
                    .animation(.linear(duration: 0.3), value: transition)
            )
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct ButtonSwitch_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.opacity(0.3)
                .ignoresSafeArea()
            
            ButtonSwitch(switchButton: .constant(true))
        }
    }
}
