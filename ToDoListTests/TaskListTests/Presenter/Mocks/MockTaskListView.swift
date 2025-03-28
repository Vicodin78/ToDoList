//
//  MockTaskListView.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

class MockTaskListView: TaskListPresenterOutput {
    var displayedTasks: [Task]?
    var displayedNotCompletedTasksCount: Int?
    var displayedError: Error?
    
    func displayTasks(_ tasks: [Task], _ notCompletedTasksCount: Int) {
        print("displayTasks вызван")
        self.displayedTasks = tasks
        self.displayedNotCompletedTasksCount = notCompletedTasksCount
    }
    
    func displayError(_ error: Error) {
        self.displayedError = error
    }
}
