//
//  MockTaskListInteractor.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

class MockTaskListInteractor: TaskListInteractorInput {
    
    weak var presenter: TaskListInteractorOutput?
    
    var mockTasks: [Task] = []
    var mockError: Error?
    
    var saveTaskCalled = false
    var deleteTaskCalled = false
    
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        if let error = mockError {
            completion(.failure(error))
        } else {
            completion(.success(mockTasks))
        }
    }
    
    func filterTasks(with query: String, completion: (() -> Void)?) {
        let filtered = mockTasks.filter { $0.title.contains(query) }
        presenter?.didFilterTasks(filtered)
        completion?()
    }
    
    func saveTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        mockTasks = [task]
        saveTaskCalled = true
        completion(.success(()))
    }
    
    func deleteTask(withId taskId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        mockTasks.removeAll()
        deleteTaskCalled = true
        completion(.success(()))
    }
}
