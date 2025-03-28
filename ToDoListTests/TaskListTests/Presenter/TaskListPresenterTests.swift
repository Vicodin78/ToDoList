//
//  TaskListPresenterTests.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

class TaskListPresenterTests: XCTestCase {
    
    var presenter: TaskListPresenter!
    var mockView: MockTaskListView!
    var mockInteractor: MockTaskListInteractor!
    
    override func setUp() {
        super.setUp()
        mockView = MockTaskListView()
        mockInteractor = MockTaskListInteractor()
        presenter = TaskListPresenter(view: mockView, interactor: mockInteractor)
        mockInteractor.presenter = presenter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    // MARK: - Проверяем, что когда вызывается viewDidLoad, презентер правильно запрашивает задачи у interactor и передает их на view
    func testViewDidLoad_Success() {
        let mockTasks = [
            Task(id: 1, title: "Test Task 1", description: "Description 1", createdAt: Date(), isCompleted: false),
            Task(id: 2, title: "Test Task 2", description: "Description 2", createdAt: Date(), isCompleted: true)
        ]
        mockInteractor.mockTasks = mockTasks
        
        presenter.viewDidLoad()
        
        XCTAssertEqual(mockView.displayedTasks?.count, 2)
        XCTAssertEqual(mockView.displayedNotCompletedTasksCount, 1)
    }
    
    
    func testViewDidLoad_Failure() {
        let expectedError = NSError(domain: "TestError", code: 0, userInfo: nil)
        mockInteractor.mockError = expectedError
        
        presenter.viewDidLoad()
        
        XCTAssertEqual(mockView.displayedError as NSError?, expectedError)
    }
    
    // MARK: - Проверяем, что презентер фильтрует задачи на основе строки поиска
    func testSearchTasks_WithQuery() {
        let task1 = Task(id: 1, title: "Buy milk", description: "Get some milk", createdAt: Date(), isCompleted: false)
        let task2 = Task(id: 2, title: "Go running", description: "Run 5km", createdAt: Date(), isCompleted: false)
        mockInteractor.mockTasks = [task1, task2]
        
        let expectation = self.expectation(description: "Task Search successfully")
        
        presenter.searchTasks(with: "Buy", completion: {
            XCTAssertEqual(self.mockView.displayedTasks?.count, 1)
            XCTAssertEqual(self.mockView.displayedTasks?.first?.description, "Get some milk")
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Проверяем обновление задачи
    func testUpdateTask_Success() {
        let task = Task(id: 1, title: "Updated Task", description: "Updated Description", createdAt: Date(), isCompleted: true)

        presenter.updateTask(task)
        
        XCTAssertTrue(self.mockInteractor.saveTaskCalled)
        XCTAssertEqual(self.mockView.displayedTasks?.first?.title, task.title)
    }
    
    // MARK: - Проверяем удаление задачи
    func testDeleteTask_Success() {
        let taskId = 1
        
        presenter.deleteTask(taskId: taskId) { success in
            XCTAssertTrue(success)
            XCTAssertTrue(self.mockInteractor.deleteTaskCalled)
            XCTAssertTrue(self.mockView.displayedTasks?.isEmpty ?? false)
        }
        
    }
    
    // MARK: - Проверяем что метод передает данные только в случае если происходит поиск
    func testDidFilterTasks() {
        let task1 = Task(id: 2, title: "Go running", description: "Run 5km", createdAt: Date(), isCompleted: false)
        
        presenter.didFilterTasks([task1])
        
        XCTAssertEqual(mockView.displayedTasks?.count, 0)
        XCTAssertNotEqual(mockView.displayedTasks?.first?.title, "Go running")
    }
    
    // MARK: - Проверяем что метод передает ошибку
    func testDisplayError() {
        let error = NSError(domain: "Test", code: 99, userInfo: ["Test error message": "Some error"])
        print("error.localizedDescription: \(error)")
        
        presenter.displayError(error)
        
        XCTAssertNotNil(mockView.displayedError)
    }
}
