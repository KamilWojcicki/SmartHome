//
//  Extenstions.swift
//  
//
//  Created by Kamil Wójcicki on 19/09/2023.
//

import SwiftUI

private struct RGBAParser {
    internal let hex: String

    var normalized: UInt32 {
        var color = String(hex.dropFirst(hex.hasPrefix("#") ? 1 : 0))
        if color.count == 6 {
            color += "ff"
        }

        var hexNumber: UInt64 = 0
        Scanner(string: color).scanHexInt64(&hexNumber)

        return UInt32(hexNumber)
    }
}

private struct RGBAComponents {
    internal let rgba: UInt32

    private var shifts: [UInt32] {
        [
            (rgba & 0xff000000) >> 24,
            (rgba & 0x00ff0000) >> 16,
            (rgba & 0x0000ff00) >> 8,
            (rgba & 0x000000ff)
        ]
    }

    private var components: [CGFloat] {
        shifts.map { CGFloat($0 & 0xff) }
    }

    internal var normalized: [CGFloat] {
        components.map { $0 / 255.0 }
    }
}

extension Color {
    internal init(_ hex: String) {
        let rgba = RGBAParser(hex: hex).normalized
        let rgbaComponents = RGBAComponents(rgba: rgba).normalized

        self.init(
            .sRGB,
            red: rgbaComponents[0],
            green: rgbaComponents[1],
            blue: rgbaComponents[2],
            opacity: rgbaComponents[3]
        )
    }
}
