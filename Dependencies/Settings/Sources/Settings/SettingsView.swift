//
//  SettingsView.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import Components
import Design
import SwiftUI
import SettingsInterface

public struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    public init() { }
    
    public var body: some View {
        ScrollView {
            VStack {
                Image(asset: Icons.logoKEM)
                    .resizable()
                    .scaledToFit()
                
                Row(
                    symbol: "moon.stars.fill",
                    variant: .toggle(
                        text: "Dark mode",
                        binding: $viewModel.toogle
                    )
                )
                
                Row(
                    symbol: "character.bubble.fill",
                    variant: .language(
                        text: "Language",
                        options: viewModel.languageOptions,
                        selectedOption: $viewModel.selectedOption
                    )
                )
                
                Row(
                    symbol: "doc.text.fill",
                    variant: .plainText(
                        text: "Privacy Policy",
                        action: { }
                    )
                )
                
                Row(
                    symbol: "list.star",
                    variant: .plainText(
                        text: "Terms & Conditions",
                        action: { }
                    )
                )
                
                Row(
                    symbol: "envelope.fill",
                    variant: .plainText(
                        text: "Contact Us",
                        action: { }
                    )
                )
                
                Row(
                    symbol: "person.2.fill",
                    variant: .plainText(
                        text: "Our Team",
                        action: { }
                    )
                )
                
                Row(
                    symbol: "power",
                    variant: .plainText(
                        text: "Sign Out",
                        action: {
                            do {
                                try viewModel.signOut()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    )
                )
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(Colors.jaffa)
                        .contentShape(Rectangle())
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SettingsView()
}
