//
//  Calendar+Extension.swift
//
//
//  Created by Kamil Wójcicki on 15/10/2023.
//

import Foundation

extension Calendar {
    /// - Returns 24 hours in a day
    public var hours: [Date] {
        let startOfDay = self.startOfDay(for: Date())
        var hours: [Date] = []
        for hoursIndex in 0..<24 {
            if let date = self.date(byAdding: .hour, value: hoursIndex, to: startOfDay) {
                hours.append(date)
            }
        }
        return hours
    }
    
    /// - Returns current week in Array format
    public var currentWeek: [WeekDay] {
        guard let firstWeekDay = self.dateInterval(of: .weekOfMonth, for: Date())?.start else { return [] }
        var week: [WeekDay] = []
        for dayIndex in 0..<7 {
            if let day = self.date(byAdding: .day, value: dayIndex, to: firstWeekDay) {
                let weekDaySymbol: String = day.toString("EEEE")
                let isToday = self.isDateInToday(day)
                week.append(.init(string: weekDaySymbol, date: day, isToday: isToday))
            }
        }
        return week
    }
    
   public struct WeekDay: Identifiable {
        public var id: UUID = .init()
        public var string: String
        public var date: Date
        public var isToday: Bool = false
    }
}
