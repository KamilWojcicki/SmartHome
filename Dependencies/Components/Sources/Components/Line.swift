//
//  Line.swift
//
//
//  Created by Kamil Wójcicki on 18/09/2023.
//

import SwiftUI

struct Line: Shape {
    
    enum Variant {
        case horizontal
        case vertical
    }
    
    private let variant: Variant
    
    init(variant: Variant) {
        self.variant = variant
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        switch  variant {
        case .horizontal:
            path.move(to: CGPoint(x: 0, y: rect.height / 2))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        case .vertical:
            path.move(to: CGPoint(x: rect.width / 2, y: 0))
            path.addLine(to: CGPoint(x: rect.width / 2, y: rect.height))
        }
        return path
    }
}
