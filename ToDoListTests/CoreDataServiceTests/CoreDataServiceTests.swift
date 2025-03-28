//
//  CoreDataServiceTests.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList
import CoreData

class CoreDataServiceTests: XCTestCase {

    var coreDataService: TestCoreDataService!
    
    override func setUp() {
        super.setUp()
        coreDataService = TestCoreDataService()
    }
    
    override func tearDown() {
        coreDataService = nil
        super.tearDown()
    }

    func testSaveAndFetchTask() {
        let task = Task(id: 1, title: "Test Task", description: "Test Description", createdAt: Date(), isCompleted: false)

        let expectation = self.expectation(description: "Task saved and fetched")
        
        coreDataService.saveTask(task) { result in
            switch result {
            case .success:
                self.coreDataService.fetchTasks { result in
                    switch result {
                    case .success(let tasks):
                        XCTAssertEqual(tasks.count, 1, "Задача должна быть сохранена в количестве 1 штуки")
                        XCTAssertEqual(tasks.first?.title, "Test Task", "Заголовок задачи должен соответсвовать 'Test Task")
                        expectation.fulfill()
                    case .failure(let error):
                        XCTFail("Failed to fetch tasks: \(error)")
                    }
                }
            case .failure(let error):
                XCTFail("Failed to save task: \(error)")
            }
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testDeleteTask_Success() {
        let task = Task(id: 1, title: "Test Task to Delete", description: "Test Description", createdAt: Date(), isCompleted: false)
        
        let expectation = self.expectation(description: "Task saved, delete, and not found")
        
        coreDataService.saveTask(task) { result in
            switch result {
            case .success:
                self.coreDataService.fetchTasks { result in
                    switch result {
                    case .success(let tasks):
                        self.coreDataService.deleteTask(tasks[0].id) { result in
                            switch result {
                            case .success():
                                self.coreDataService.fetchTasks { result in
                                    switch result {
                                    case .success(let tasks):
                                        XCTAssertFalse(tasks.contains(where: { $0.id == task.id }), "Задача должна быть удалена")
                                        XCTAssertTrue(tasks.isEmpty, "Задача должна быть удалена")
                                        expectation.fulfill()
                                    case .failure(let error):
                                        XCTFail("Failed to fetch task: \(error)")
                                    }
                                }
                            case .failure(let error):
                                XCTFail("Failed to fetch task: \(error)")
                            }
                        }
                    case .failure(let error):
                        XCTFail("Failed to fetch task: \(error)")
                    }
                }
            case .failure(let error):
                XCTFail("Failed to save task: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testDeleteTask_Failure() {
        let task = Task(id: 1, title: "Test Task to Delete", description: "Test Description", createdAt: Date(), isCompleted: false)
        
        let expectation = self.expectation(description: "Not found task for delete")
        
        coreDataService.saveTask(task) { result in
            switch result {
            case .success():
                self.coreDataService.deleteTask(99) { result in
                    switch result {
                    case .success():
                        XCTFail("Expected failure but got success")
                    case .failure(let error):
                        XCTAssertNotNil(error, "Должна быть ошибка удаления")
                        self.coreDataService.fetchTasks { result in
                            switch result {
                            case .success(let tasks):
                                XCTAssertFalse(tasks.isEmpty, "Хранилище задач должно быть пустым")
                                expectation.fulfill()
                            case .failure(let error):
                                XCTFail("Failed to fetch task: \(error)")
                            }
                        }
                    }
                }
            case .failure(let error):
                XCTFail("Failed to save task: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testSaveTasks_RemoteTasks() {
        let remoteTasks: [RemoteTask] = [
            RemoteTask(id: 1, title: "Купить молоко", description: "Зайти в магазин и купить молоко", createdAt: Date(), isCompleted: false),
            RemoteTask(id: 2, title: "Написать тесты", description: "Написать юнит-тесты для CoreDataService", createdAt: Date(), isCompleted: true)
        ]
        
        let expectation = self.expectation(description: "Save Remote Tasks")
        
        coreDataService.saveTasks(remoteTasks) { result in
            switch result {
            case .success():
                self.coreDataService.fetchTasks { result in
                    switch result {
                    case .success(let tasks):
                        XCTAssertEqual(tasks.count, remoteTasks.count, "Должно быть сохранено то же количетсво элементов")
                        XCTAssertTrue(tasks.contains(where: {$0.title == remoteTasks.first?.title}), "Добавленный элемент должен содержаться в списке")
                        expectation.fulfill()
                    case .failure(let error):
                        XCTFail("Failed to fetch task: \(error)")
                    }
                }
            case .failure(let error):
                XCTFail("Failed to save task: \(error)")
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}

