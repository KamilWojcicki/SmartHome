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
    @State private var toogle: Bool = false
    private let languageOptions: [String] = [
        "Polish", "English"
    ]
    @State private var selectedOption: String = "English"
    @StateObject private var viewModel = SettingsViewModel()
    
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
                        binding: $toogle
                    )
                )
                
                Row(
                    symbol: "character.bubble.fill",
                    variant: .language(
                        text: "Language",
                        options: [
                            languageOption.pl.rawValue,
                            languageOption.eng.rawValue
                        ],
                        selectedOption: $selectedOption
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
        .ignoresSafeArea()
    }
}

#Preview {
    SettingsView()
}
