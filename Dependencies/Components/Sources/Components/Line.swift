//
//  Line.swift
//  
//
//  Created by Kamil Wójcicki on 18/09/2023.
//

import SwiftUI

internal struct Line: Shape {
    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}
