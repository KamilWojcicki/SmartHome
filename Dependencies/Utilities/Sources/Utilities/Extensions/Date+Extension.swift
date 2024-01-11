//
//  Date+Extension.swift
//
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import Foundation

extension Date {
    public func toString(_ format: String, locale: Locale = Locale.current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: self)
    }
}
