//
//  Mocks.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class MockAddTaskView: AddTaskPresenterOutput {
    private(set) var displayedError: (Error, (() -> Void)?)?

    func displayError(_ error: any Error, _ popAction: @escaping (() -> Void)) {
        displayedError = (error, popAction)
    }
}

final class MockAddTaskInteractor: AddTaskInteractorInput {
    private(set) var savedTask: Task?
    var saveResult: Result<Void, Error> = .success(())

    func saveTask(task: Task, completion: @escaping (Result<Void, any Error>) -> Void) {
        savedTask = task
        completion(saveResult)
    }
}

final class MockAddTaskRouter: AddTaskRouterInput {
    private(set) var didDismiss = false

    func dismiss() {
        didDismiss = true
    }
}
