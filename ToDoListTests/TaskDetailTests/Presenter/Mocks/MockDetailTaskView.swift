//
//  MockDetailTaskView.swift
//  ToDoListTests
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class MockDetailTaskView: DetailTaskPresenterOutput {
    
    private(set) var displayedTask: Task?
    private(set) var displayedError: (Error, (() -> Void)?)?
    private(set) var popActionCalled: Bool = false

    func displayTask(_ task: Task) {
        displayedTask = task
    }

    func displayError(_ error: any Error, _ popAction: @escaping (() -> Void)) {
        displayedError = (error, popAction)
        popAction()
        popActionCalled = true
    }
}
