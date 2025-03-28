//
//  ParentTaskViewTests.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class MockPresenter {}

final class TestableTaskViewController: TaskViewController<MockPresenter> {
    var saveTaskCalled = false

    override func saveTask() {
        saveTaskCalled = true
    }
}

final class TaskViewControllerTests: XCTestCase {
    
    var sut: TestableTaskViewController!
    
    override func setUp() {
        super.setUp()
        sut = TestableTaskViewController()
        sut.presenter = MockPresenter()
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_displayTask_setsTaskData() {
        let task = Task(id: Int.random(in: 0..<1000), title: "Test Task", description: "Test Description", createdAt: Date(), isCompleted: false)
        
        sut.displayTask(task)
        
        XCTAssertEqual(sut.taskNameTextField.text, task.title)
        XCTAssertEqual(sut.taskBodyTextView.text, task.description)
    }

    func test_editingEnablesDoneButton() {
        sut.textFieldDidBeginEditing(sut.taskNameTextField)
        XCTAssertTrue(sut.navigationItem.rightBarButtonItem?.isEnabled ?? false)
        
        sut.textViewDidBeginEditing(sut.taskBodyTextView)
        XCTAssertTrue(sut.navigationItem.rightBarButtonItem?.isEnabled ?? false)
    }
}
