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
        case weather(temperature: String, time: String, date: String, symbol: String)
        case device(text: String, binding: Binding<Bool>, symbol: String)
        case deviceSchedule(text: String, plannedTime: String, state: String, symbol: String)
    }
    
    public enum State: String {
        case zero = "0"
        case one = "1"
    }
    
    private let variant: Variant
    
    public init(variant: Variant) {
        self.variant = variant
    }
    
    public var body: some View {
        ZStack {
            Colors.oxfordBlue
                .frame(maxWidth: .infinity)
                .frame(height: 150)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Colors.jaffa, lineWidth: 3)
                )
            
            buildTileView(for: variant)
        }
    }
    
    @ViewBuilder
    private func buildTileView(for variant: Variant) -> some View {
        switch variant {
        case .weather(let temperature, let time, let date, let symbol):
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
            
        case .device(let text, let binding, let symbol):
            HStack {
                VStack {
                    Text(text)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
                .frame(maxWidth: 105)
                .font(.system(size: 60))
                
            }
            .foregroundStyle(Colors.white)
            .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
            
        case .deviceSchedule(text: let text, plannedTime: let plannedTime, state: let state, let symbol):
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
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(5)
                
                Line(variant: .vertical)
                    .stroke(style: StrokeStyle(dash: [5]))
                    .frame(width: 1, height: 150)
                    .foregroundColor(Colors.nobel)
                
                VStack(spacing: 20) {
                    Image(systemName: symbol)
                        .foregroundStyle(state == State.one.rawValue ? Colors.barberry : Colors.white)
                        .font(.system(size: 60))
                    
                    
                    Text(state == State.one.rawValue ? "ON" : "OFF")
                }
                .padding(.horizontal, 10)
                .frame(minWidth: 110)
                
            }
            .foregroundStyle(Colors.white)
            .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
        }
    }
}

#Preview {
    VStack {
        Tile(variant: .weather(temperature: "12", time: "12:00", date: "12.02.2023", symbol: ""))
        
        Tile(variant: .device(text: "LIGHT", binding: .constant(true), symbol: ""))
        
        Tile(variant: .deviceSchedule(text: "Turn the light on", plannedTime: "10.12.2023", state: "1", symbol: ""))
    }
    .padding()
    
    
}
