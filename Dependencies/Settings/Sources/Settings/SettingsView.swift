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
        GeometryReader { reader in
            ZStack {
                ScrollView {
                    VStack {
                        image
                        
                        buildDarkModeRow()
                        
                        buildChangeLanguageRow()
                        
                        buildPrivacyPolicyRow()
                        
                        buildTermsConditionRow()
                        
                        buildContactRow()
                        
                        buildOurTeamRow()
                        
                        buildLogOutRow()
                        
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
                
                buildSheet(size: reader.size)
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    @ViewBuilder
    private func buildSheet(size: CGSize) -> some View {
        CustomSheet(size: size, item: $viewModel.activeSheet) { sheet in
            switch sheet {
            case .ourTeam:
                buildOurTeamContent()
            case .privacyPolicy:
                buildPrivacyPolicyContent()
            case .termsAndConditions:
                buildTermsAndConditionsContent()
            }
        }
    }
    
    @ViewBuilder
    private func buildOurTeamContent() -> some View {
        ScrollView {
            VStack {
                Text(ActiveSheet.ourTeam.description)   
            }
        }
    }
    
    @ViewBuilder
    private func buildPrivacyPolicyContent() -> some View {
        ScrollView {
            VStack {
                Text(ActiveSheet.privacyPolicy.description)
                    .font(.headline)
            }
        }
    }
    
    @ViewBuilder
    private func buildTermsAndConditionsContent() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(ActiveSheet.termsAndConditions.description)
                    .font(.headline)
            }
        }
    }
    
    private var image: some View {
        Image(asset: Icons.logoKEM)
            .resizable()
            .scaledToFit()
    }
    
    @ViewBuilder
    private func buildDarkModeRow() -> some View {
        Row(
            symbol: "moon.stars.fill",
            variant: .toggle(
                text: "dark_mode_button_title".localized,
                binding: $viewModel.toogle
            )
        )
    }
    
    @ViewBuilder
    private func buildChangeLanguageRow() -> some View {
        Row(
            symbol: "character.bubble.fill",
            variant: .plainText(
                text: "change_language_button_title".localized,
                action: {
                    viewModel.openSettings()
                }
            )
        )
    }
    
    @ViewBuilder
    private func buildPrivacyPolicyRow() -> some View {
        Row(
            symbol: "doc.text.fill",
            variant: .plainText(
                text: "privacy_policy_button_title".localized,
                action: {
                    viewModel.showSheet(activeSheet: .privacyPolicy)
                }
            )
        )
    }
    
    @ViewBuilder
    private func buildTermsConditionRow() -> some View {
        Row(
            symbol: "list.star",
            variant: .plainText(
                text: "terms_and_conditions_button_title".localized,
                action: {
                    viewModel.showSheet(activeSheet: .termsAndConditions)
                }
            )
        )
    }
    
    @ViewBuilder
    private func buildContactRow() -> some View {
        Row(
            symbol: "envelope.fill",
            variant: .plainText(
                text: "contact_us_button_title".localized,
                action: { }
            )
        )
    }
    
    @ViewBuilder
    private func buildOurTeamRow() -> some View {
        Row(
            symbol: "person.2.fill",
            variant: .plainText(
                text: "our_team_button_title".localized,
                action: {
                    viewModel.showSheet(activeSheet: .ourTeam)
                }
            )
        )
    }
    
    @ViewBuilder
    private func buildLogOutRow() -> some View {
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
    }
}
