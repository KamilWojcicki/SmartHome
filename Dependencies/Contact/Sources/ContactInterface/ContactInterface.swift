//
//  ContactInterface.swift
//
//
//  Created by Kamil Wójcicki on 14/12/2023.
//

import Foundation

public struct MailData {
    public struct AttachmentData {
        public var data: Data
        public var mimeType: String
        public var fileName: String
        
        public init(
            data: Data,
            mimeType: String,
            fileName: String
        ) {
            self.data = data
            self.mimeType = mimeType
            self.fileName = fileName
        }
    }
    
    public var subject: String
    public var recipients: [String]
    public var body: String
    public var isBodyHTML = false
    public var attachments = [AttachmentData]()
    
    public init(
        subject: String,
        recipients: [String],
        body: String,
        isBodyHTML: Bool = false,
        attachments: [AttachmentData] = []
    ) {
        self.subject = subject
        self.recipients = recipients
        self.body = body
        self.isBodyHTML = isBodyHTML
        self.attachments = attachments
    }
}
