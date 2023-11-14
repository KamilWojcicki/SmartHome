//
//  Tile.swift
//
//
//  Created by Kamil Wójcicki on 10/11/2023.
//

import Design
import SwiftUI

public struct Tile: View {
    
    public enum Variant {
        case weather(temperature: String, time: String, date: String)
        case device(text: String, plannedTime: String, binding: Binding<Bool>)
    }
    
    private let symbol: String
    private let variant: Variant
    
    public init(symbol: String, variant: Variant) {
        self.symbol = symbol
        self.variant = variant
    }
    
    public var body: some View {
        ZStack {
            Colors.oxfordBlue
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .cornerRadius(15)
            
            buildTileView(for: variant)
        }
    }
    
    @ViewBuilder
    private func buildTileView(for variant: Variant) -> some View {
        switch variant {
        case .weather(let temperature, let time, let date):
            VStack {
                HStack {
                    Text(temperature)
                    
                    Spacer()
                    
                    Image(systemName: symbol)
                }
                .padding(.horizontal)
                
                Line(variant: .horizontal)
                    .stroke(style: StrokeStyle(dash: [5]))
                    .frame(height: 1)
                    .foregroundColor(Colors.nobel)
                
                HStack {
                    Text(time)
                    
                    Spacer()
                    
                    Text(date)
                }
                .padding(.horizontal)
            }
            .withTextStyleViewModifier()
            
        case .device(let text,let plannedTime, let binding):
            HStack {
                VStack {
                    Text(text)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                    
                    Spacer()
                    
                    Text("Planned at: \(plannedTime)")
                        .font(.footnote)
                        .foregroundStyle(Colors.nobel)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(width: 230, alignment: .leading)
                .padding(5)
                
                Line(variant: .vertical)
                    .stroke(style: StrokeStyle(dash: [5]))
                    .frame(width: 1, height: 150)
                    .foregroundColor(Colors.nobel)
                
                VStack(spacing: 20) {
                    Image(systemName: symbol)
                        .foregroundStyle(binding.wrappedValue ? Colors.barberry : Colors.white)
                        
                    
                    HStack {
                        Toggle(isOn: binding) {
                            Text(binding.wrappedValue ? "On" : "Off")
                                .font(.callout)
                        }
                        .tint(Colors.jaffa)
                    }
                    .padding(.horizontal, 10)
                }
                .frame(maxWidth: .infinity)
                .font(.system(size: 60))
                
            }
            .foregroundStyle(Colors.white)
            .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
        }
    }
}

#Preview {
    VStack {
        Tile(symbol: "star", variant: .weather(temperature: "12", time: "12:00", date: "12.02.2023"))
        
        Tile(symbol: "star", variant: .device(text: "Turn the light on", plannedTime: "10.12.2023", binding: .constant(true)))
    }
    .padding()
    
    
}
