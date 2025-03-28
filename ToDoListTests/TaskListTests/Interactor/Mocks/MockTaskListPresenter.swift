//
//  MockTaskListPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class MockTaskListPresenter: TaskListInteractorOutput {
    var filteredTasks: [Task]?
    var displayedError: Error?
    
    func didFilterTasks(_ tasks: [Task]) {
        print("получил в презентер \(String(describing: tasks.first))")
        filteredTasks = tasks
    }
    
    func displayError(_ error: Error) {
        displayedError = error
    }
}
