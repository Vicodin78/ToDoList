//
//  DateParser.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

import Foundation

final class DateParser {
    
    private static func parseDateHelper(from string: String) -> Date? {
        let dateFormats = [
            "dd",
            "MM",
            "yyyy",
            "MM/dd",
            "dd/MM",
            "dd/MM/yyyy",
            "MM/dd/yyyy",
            "yyyy-MM-dd",
            "yyyy/MM/dd"
        ]
        
        for format in dateFormats {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: string) {
                return date
            }
        }
        return nil
    }
    
    static func parseDate(task: Task, with query: String) -> Bool {
       
        var createdAtMatch = false
        if let date = parseDateHelper(from: query) {
            // Полная дата
            if query.count == 10 {
                createdAtMatch = Calendar.current.isDate(task.createdAt, inSameDayAs: date)
            }
            // День и месяц
            else if query.count == 5 {
                let taskDateComponents = Calendar.current.dateComponents([.day, .month], from: task.createdAt)
                let inputComponents = Calendar.current.dateComponents([.day, .month], from: date)
                
                createdAtMatch = taskDateComponents.day == inputComponents.day && taskDateComponents.month == inputComponents.month
            }
            // Только день
            else if query.count == 2 {
                let taskDay = Calendar.current.component(.day, from: task.createdAt)
                let inputDay = Calendar.current.component(.day, from: date)
                
                createdAtMatch = taskDay == inputDay
            }
            // Только месяц
            else if query.count == 2 {
                let taskMonth = Calendar.current.component(.month, from: task.createdAt)
                let inputMonth = Calendar.current.component(.month, from: date)
                
                createdAtMatch = taskMonth == inputMonth
            }
            // Только год
            else if query.count == 4 {
                let taskYear = Calendar.current.component(.year, from: task.createdAt)
                let inputYear = Calendar.current.component(.year, from: date)
                
                createdAtMatch = taskYear == inputYear
            }
        }
        return createdAtMatch
    }
}
