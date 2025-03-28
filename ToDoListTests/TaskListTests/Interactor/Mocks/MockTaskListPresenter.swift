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
        filteredTasks = tasks
    }
    
    func displayError(_ error: Error) {
        displayedError = error
    }
}
