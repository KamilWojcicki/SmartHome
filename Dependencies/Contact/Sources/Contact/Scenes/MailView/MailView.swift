//
//  MailView.swift
//
//
//  Created by Kamil Wójcicki on 14/12/2023.
//

import ContactInterface
import MessageUI
import SwiftUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.isPresented) private var isPresented
    let mailData: MailData
    var result: (Result<MFMailComposeResult, Error>) -> Void
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setSubject(mailData.subject)
        mailComposer.setToRecipients(mailData.recipients)
        mailComposer.navigationItem.rightBarButtonItem?.isEnabled = false
        mailComposer.setMessageBody(mailData.body, isHTML: mailData.isBodyHTML)
        
        for attachment in mailData.attachments {
            mailComposer.addAttachmentData(
                attachment.data,
                mimeType: attachment.mimeType,
                fileName: attachment.fileName
            )
        }
        
        if MFMailComposeViewController.canSendMail() {
            result(.success(.sent))
        }
        
        return mailComposer
    }
    
    func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        private var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            if let error {
                parent.result(.failure(error))
                return
            }
            
            parent.result(.success(result))
            controller.dismiss(animated: true)
        }
    }
}
