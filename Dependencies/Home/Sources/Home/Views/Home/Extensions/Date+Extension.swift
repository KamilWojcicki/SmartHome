//
//  Date+Extension.swift
//
//
//  Created by Kamil Wójcicki on 23/11/2023.
//

import Foundation

extension Date {
    public func formatDateAndTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

