//
//  PopOverMenuInteractorTests.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

final class PopOverMenuInteractorTests: XCTestCase {
    
    var sut: PopOverMenuInteractor!
    var mockPresenter: MockPopOverMenuPresenter!
    var mockCoreDataService: MockCoreDataService!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockPopOverMenuPresenter()
        mockCoreDataService = MockCoreDataService()
        
        sut = PopOverMenuInteractor()
        sut.presenter = mockPresenter
        sut.coreDataService = mockCoreDataService
    }
    
    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockCoreDataService = nil
        super.tearDown()
    }
    
    func test_fetchData_returnsMenuItems() {
        let items = sut.fetchData()
        
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items[0].title, "Редактировать")
        XCTAssertEqual(items[1].title, "Поделиться")
        XCTAssertEqual(items[2].title, "Удалить")
    }
    
    func testDeleteTask() {
        let taskToDelete: Task = .init(id: 1, title: "Test task", description: "", createdAt: Date(), isCompleted: false)
        mockCoreDataService.tasks = [taskToDelete]
        
        sut.deleteTask(withId: taskToDelete.id)
        
        XCTAssertFalse(self.mockCoreDataService.tasks.contains { $0.id == taskToDelete.id })
    }
    
    func test_deleteTask_success_callsDismissPopOver() {
        mockCoreDataService.shouldFail = false
        
        sut.deleteTask(withId: 1)
        
        XCTAssertTrue(mockPresenter.dismissPopOverCalled)
    }
    
    func test_deleteTask_failure_doesNotCallDismissPopOver() {
        mockCoreDataService.shouldFail = true
        
        sut.deleteTask(withId: 1)
        
        XCTAssertFalse(mockPresenter.dismissPopOverCalled)
    }
}
