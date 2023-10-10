//
//  DeviceTile.swift
//  
//
//  Created by Kamil Wójcicki on 18/09/2023.
//

import SwiftUI
import Design

//public struct DeviceTile: View {
//    
//    @State private var weathers: [WeatherApiModel] = [
//        WeatherApiModel(temperature: 12, time: Date(), weatherIcon: "cloud.sun", date: .now)
//    ]
//    @State private var testAPI = WeatherApiModel(temperature: 12, time: Date(), weatherIcon: "cloud.sun", date: .now)
//    
//   public var body: some View {
//        ZStack {
//            Colors.oxfordBlue
//                .frame(maxWidth: .infinity)
//                .frame(height: 150)
//                .cornerRadius(15)
//            
//            VStack {
//                HStack {
//                    Text(testAPI.fullTemp)
//                    
//                    Spacer()
//                    
//                    Image(systemName: testAPI.weatherIcon)
//                }
//                .padding(.horizontal)
//                
//                Line()
//                    .stroke(style: StrokeStyle(dash: [5]))
//                    .frame(height: 1)
//                    .foregroundColor(Colors.nobel)
//                
//                HStack {
//                    Text("\(testAPI.displayTime)")
//                    
//                    Spacer()
//                    
//                    Text("\(testAPI.displayDate)")
//                }
//                .padding(.horizontal)
//            }
//            .withTextStyleViewModifier()
//        }
//    }
//}
//
//struct DeviceTile_Previews: PreviewProvider {
//    static var previews: some View {
//        DeviceTile()
//    }
//}
