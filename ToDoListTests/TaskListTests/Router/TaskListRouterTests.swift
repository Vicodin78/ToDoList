//
//  TaskListRouterTests.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

class TaskListRouterTests: XCTestCase {
    
    var router: TaskListRouter!
    var viewControllerMock: ViewControllerMockForTaskList!
    
    override func setUp() {
        super.setUp()
        router = TaskListRouter()
        viewControllerMock = ViewControllerMockForTaskList()
        router.viewController = viewControllerMock
    }
    
    override func tearDown() {
        router = nil
        viewControllerMock = nil
        super.tearDown()
    }
    
    func test_navigateToTaskDetail_pushesViewController() {
        let task = Task(id: 1, title: "Test Task", description: "Description", createdAt: Date(), isCompleted: false)
        
        router.navigateToTaskDetail(task: task)
        
        XCTAssertTrue(viewControllerMock.didPushViewController)
    }
    
    func test_navigateToAddTaskView_pushesViewController() {
        router.navigateToAddTaskView()
        
        XCTAssertTrue(viewControllerMock.didPushViewController)
    }
    
    func test_navigateToPopOverCell_presentsViewController() {
        let task = Task(id: 1, title: "Test Task", description: "Description", createdAt: Date(), isCompleted: false)
        let position = CGPoint(x: 100, y: 100)
        
        router.navigateToPopOverCell(with: task, at: position)
        
        XCTAssertTrue(viewControllerMock.didPresentViewController)
    }
}
