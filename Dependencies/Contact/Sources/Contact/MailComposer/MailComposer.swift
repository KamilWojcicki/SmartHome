//
//  MailComposer.swift
//
//
//  Created by Kamil Wójcicki on 14/12/2023.
//

import ContactInterface
import MessageUI
import SwiftUI

struct MailComposer: ViewModifier {
    @Binding private var isPresented: Bool
    private var mailData: MailData
    private var onDismiss: (() -> Void)?
    private var result: ((Result<MFMailComposeResult, Error>) -> Void)?
    
    init(
        isPresented: Binding<Bool>,
        mailData: MailData,
        onDismiss: (() -> Void)? = nil,
        result: ((Result<MFMailComposeResult, Error>) -> Void)? = nil
    ) {
        self._isPresented = isPresented
        self.mailData = mailData
        self.onDismiss = onDismiss
        self.result = result
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .sheet(
                isPresented: $isPresented,
                onDismiss: onDismiss
            ) {
                if MFMailComposeViewController.canSendMail() {
                    MailView(
                        mailData: mailData) { result in
                            self.result?(result)
                        }
                }
            }
    }
}

extension View {
    public func mailComposer(
        isPresented: Binding<Bool>,
        mailData: MailData,
        onDismiss: (() -> Void)? = nil,
        result: ((Result<MFMailComposeResult, Error>) -> Void)? = nil
    ) -> some View {
        self.modifier(
            MailComposer(
                isPresented: isPresented,
                mailData: mailData,
                onDismiss: onDismiss,
                result: result
            )
        )
    }
}
