//
//  Line.swift
//  
//
//  Created by Kamil Wójcicki on 18/09/2023.
//

import SwiftUI

public struct CustomLine: View {
    
    private let startPoint: Point
    private let endPoint: Point
    
    public enum Point {
        case leading
        case trailing
        
        public var unitPoint: UnitPoint {
            switch self {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            }
        }
    }
    
    public init(startPoint: Point, endPoint: Point) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    public var body: some View {
        Rectangle()
            .frame(height: 1)
            .frame(maxWidth: UIScreen.main.bounds.width * 0.2)
            .mask(
                LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: startPoint.unitPoint, endPoint: endPoint.unitPoint)
            )
            
    }
}

struct CustomLine_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CustomLine(startPoint: .leading, endPoint: .trailing)
            CustomLine(startPoint: .trailing, endPoint: .leading)
        }
        
    }
}
