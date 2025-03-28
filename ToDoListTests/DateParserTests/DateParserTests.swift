//
//  DateParserTests.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

final class DateParserTests: XCTestCase {
    
    func testParseDate_with_FullDate() {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 7
        dateComponents.month = 8
        dateComponents.year = 2000
        
        guard let date = calendar.date(from: dateComponents) else {
            XCTFail("Ошибка подготовки даты для теста")
            return
        }
        let task = Task(id: 1, title: "Test", description: "Test description", createdAt: date, isCompleted: true)
        let query = "07/08/2000"
        
        XCTAssertTrue(DateParser.parseDate(task: task, with: query), "Дата должна быть распарсена верно")
        
    }
    
    func testParseDate_with_DayAndMonth() {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 7
        dateComponents.month = 8
        dateComponents.year = 2000
        
        guard let date = calendar.date(from: dateComponents) else {
            XCTFail("Ошибка подготовки даты для теста")
            return
        }
        let task = Task(id: 1, title: "Test", description: "Test description", createdAt: date, isCompleted: true)
        let query = "08/07"
        
        XCTAssertTrue(DateParser.parseDate(task: task, with: query), "Дата должна быть распарсена верно")
        
    }
    
    func testParseDate_with_DayOnly() {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 7
        dateComponents.month = 8
        dateComponents.year = 2000
        
        guard let date = calendar.date(from: dateComponents) else {
            XCTFail("Ошибка подготовки даты для теста")
            return
        }
        let task = Task(id: 1, title: "Test", description: "Test description", createdAt: date, isCompleted: true)
        let query = "07"
        
        XCTAssertTrue(DateParser.parseDate(task: task, with: query), "Дата должна быть распарсена верно")
        
    }
    
    func testParseDate_with_YearOnly() {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = 7
        dateComponents.month = 8
        dateComponents.year = 2000
        
        guard let date = calendar.date(from: dateComponents) else {
            XCTFail("Ошибка подготовки даты для теста")
            return
        }
        let task = Task(id: 1, title: "Test", description: "Test description", createdAt: date, isCompleted: true)
        let query = "2000"
        
        XCTAssertTrue(DateParser.parseDate(task: task, with: query), "Дата должна быть распарсена верно")
        
    }
    
}
