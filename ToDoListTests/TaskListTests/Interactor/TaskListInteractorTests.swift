//
//  TaskListInteractorTests.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class TaskListInteractorTests: XCTestCase {
    
    var interactor: TaskListInteractor!
    var mockPresenter: MockTaskListPresenter!
    var mockNetworkService: MockNetworkService!
    var mockCoreDataService: MockCoreDataService!
    var mockLaunchManager: MockFirstLaunchManager!
    
    override func setUp() {
        super.setUp()
        mockPresenter = MockTaskListPresenter()
        mockNetworkService = MockNetworkService()
        mockCoreDataService = MockCoreDataService()
        mockLaunchManager = MockFirstLaunchManager()
        
        interactor = TaskListInteractor()
        interactor.presenter = mockPresenter
        interactor.networkService = mockNetworkService
        interactor.coreDataService = mockCoreDataService
        interactor.firstLaunchManager = mockLaunchManager
    }
    
    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockNetworkService = nil
        mockCoreDataService = nil
        mockLaunchManager = nil
        super.tearDown()
    }
    
    // MARK: - Тест загрузки задач
    func testFetchTasks_isFirstLaunch_Success() {
        let mockTask = Task(id: 1, title: "Test foo", description: "testFetchTasks_isFirstLaunch_Success", createdAt: Date(), isCompleted: false)
        
        mockCoreDataService.tasks = [mockTask]
        
        mockLaunchManager.isFirstLoad = true
        
        let expectation = self.expectation(description: "Tasks fetched successfully")
        
        interactor.fetchTasks { result in
            switch result {
            case .success(let success):
                XCTAssertFalse(self.mockCoreDataService.tasks.isEmpty, "Хранилище должно содержать переданный элемент")
                XCTAssertEqual(self.mockCoreDataService.tasks.first?.description, mockTask.description, "Метод должен вернуть, а хранилище содержать такой объект")
                expectation.fulfill()
            case .failure(let failure):
                XCTFail("Expected success but got failure")
            }
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTasks_isFirstLaunch_Failure() {
        
        mockLaunchManager.isFirstLoad = true
        mockNetworkService.shouldFail = true
        
        interactor.fetchTasks { result in
            switch result {
            case .success( _):
                XCTFail("Expected failure but got success")
            case .failure( _):
                XCTAssertNotNil(self.mockPresenter.displayedError, "В презентер должна быть передана ошибка")
            }
        }
    }
    
    func testFetchTasks_Success() {
        let mockTask = Task(id: 1, title: "Test", description: "Test description", createdAt: Date(), isCompleted: false)
        mockCoreDataService.tasks = [mockTask]
        
        let expectation = self.expectation(description: "Tasks fetched successfully")
        
        interactor.fetchTasks { result in
            switch result {
            case .success(let tasks):
                XCTAssertEqual(tasks.count, 1)
                XCTAssertEqual(tasks.first?.title, "Test")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTasks_Failure() {
        mockCoreDataService.shouldFail = true
        
        let expectation = self.expectation(description: "Tasks fetch failed")
        
        interactor.fetchTasks { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Тест сохранения задачи
    func testSaveTask_Success() {
        let mockTask = Task(id: 1, title: "Test", description: "Test description", createdAt: Date(), isCompleted: false)
        
        let expectation = self.expectation(description: "Task saved successfully")
        
        interactor.saveTask(task: mockTask) { result in
            switch result {
            case .success:
                XCTAssertTrue(self.mockCoreDataService.tasks.contains { $0.id == mockTask.id })
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Тест удаления задачи
    func testDeleteTask_Success() {
        let mockTask = Task(id: 1, title: "Test", description: "Test description", createdAt: Date(), isCompleted: false)
        mockCoreDataService.tasks = [mockTask]
        
        let expectation = self.expectation(description: "Task deleted successfully")
        
        interactor.deleteTask(withId: mockTask.id) { result in
            switch result {
            case .success:
                XCTAssertFalse(self.mockCoreDataService.tasks.contains { $0.id == mockTask.id })
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Тест удаления задачи
    func testDeleteTask_Failure() {
        let mockTask = Task(id: 1, title: "Test", description: "Test description", createdAt: Date(), isCompleted: false)
        mockCoreDataService.tasks = [mockTask]
        mockCoreDataService.shouldFail = true
        
        let expectation = self.expectation(description: "Task deleted successfully")
        
        interactor.deleteTask(withId: mockTask.id) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    // MARK: - Тест фильтрации задач    
    func testFilterTasks_Failure() {
        
        mockCoreDataService.shouldFail = true
        
        interactor.filterTasks(with: "Run") {
            XCTAssertNotNil(self.mockPresenter.displayedError, "Должна содержаться ошибка получения задач")
        }
    }
    
    func testFilterTasks_NoResults() {
        let task1 = Task(id: 1, title: "Buy milk", description: "Get some milk", createdAt: Date(), isCompleted: false)
        let task2 = Task(id: 2, title: "Go running", description: "Run 5km", createdAt: Date(), isCompleted: false)
        
        mockCoreDataService.tasks = [task1, task2]
        
        let expectation = self.expectation(description: "Task Filtered successfully")
        
        interactor.filterTasks(with: "xyz") {
            XCTAssertEqual(self.mockPresenter.filteredTasks?.count, 0)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
}
