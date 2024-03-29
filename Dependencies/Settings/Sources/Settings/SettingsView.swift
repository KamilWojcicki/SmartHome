//
//  SettingsView.swift
//
//
//  Created by Kamil Wójcicki on 02/10/2023.
//

import Components
import Contact
import Design
import Localizations
import SwiftUI
import SettingsInterface

public struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    public init() { }
    
    public var body: some View {
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
            .sheet(item: $viewModel.activeSheet) { sheet in
                switch sheet {
                case .ourTeam:
                    buildOurTeamContent()
                case .privacyPolicy:
                    buildPrivacyPolicyContent()
                case .termsAndConditions:
                    buildTermsAndConditionsContent()
                }
            }
            .withAlert(errorTitle: "confirm_logout_tile".localized, errorMessageToggle: $viewModel.showAlert) {
                try? viewModel.signOut()
            }
        }
        .mailComposer(
            isPresented: $viewModel.isMailComposerPresented,
            mailData: viewModel.mailData
        )
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    @ViewBuilder
    private func buildOurTeamContent() -> some View {
        SheetContent(
            variant: .onlyText(
                text: ActiveSheet.ourTeam.description
            ), action: {
                viewModel.dismissSheet()
            }
        )
    }
    
    @ViewBuilder
    private func buildPrivacyPolicyContent() -> some View {
        SheetContent(
            variant: .onlyText(
                text: ActiveSheet.privacyPolicy.description
            ), action: {
                viewModel.dismissSheet()
            }
        )
    }
    
    @ViewBuilder
    private func buildTermsAndConditionsContent() -> some View {
        SheetContent(
            variant: .onlyText(
                text: ActiveSheet.termsAndConditions.description
            ), action: {
                viewModel.dismissSheet()
            }
        )
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
                binding: $isDarkMode
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
                action: {
                    viewModel.showMailComposer()
                }
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
                    viewModel.showAlert.toggle()
                }
            )
        )
    }
}
