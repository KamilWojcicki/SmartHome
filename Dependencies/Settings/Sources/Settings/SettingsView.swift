//
//  SettingsView.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import Components
import Design
import Localizations
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
                        text: "dark_mode_button_title".localized,
                        binding: $viewModel.toogle
                    )
                )
                
                Row(
                    symbol: "character.bubble.fill",
                    variant: .plainText(
                        text: "change_language_button_title".localized,
                        action: {
                            viewModel.openSettings()
                        }
                    )
                )
                
                Row(
                    symbol: "doc.text.fill",
                    variant: .plainText(
                        text: "privacy_policy_button_title".localized,
                        action: { }
                    )
                )
                
                Row(
                    symbol: "list.star",
                    variant: .plainText(
                        text: "terms_and_conditions_button_title".localized,
                        action: { }
                    )
                )
                
                Row(
                    symbol: "envelope.fill",
                    variant: .plainText(
                        text: "contact_us_button_title".localized,
                        action: { }
                    )
                )
                
                Row(
                    symbol: "person.2.fill",
                    variant: .plainText(
                        text: "our_team_button_title".localized,
                        action: { }
                    )
                )
                
                Row(
                    symbol: "power",
                    variant: .plainText(
                        text: "sign_out_button_title".localized,
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
