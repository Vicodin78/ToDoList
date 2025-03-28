//
//  MockCoreDataService.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class MockCoreDataService: CoreDataServiceProtocol {
    var tasks: [Task] = []
    var shouldFail = false
    
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "CoreDataError", code: 500, userInfo: nil)))
        } else {
            completion(.success(tasks))
        }
    }
    
    func saveTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "CoreDataError", code: 500, userInfo: nil)))
        } else {
            tasks.append(task)
            completion(.success(()))
        }
    }
    
    func deleteTask(_ taskID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "CoreDataError", code: 500, userInfo: nil)))
        } else {
            tasks.removeAll { $0.id == taskID }
            completion(.success(()))
        }
    }
    
    func saveTasks(_ tasks: [ToDoList.RemoteTask], completion: @escaping (Result<Void, any Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "CoreDataError", code: 500, userInfo: nil)))
        } else {
            self.tasks = tasks.map { task in
                Task(
                    id: task.id ?? 0,
                    title: task.title ?? "No title",
                    description: task.description ?? "",
                    createdAt: Date(),
                    isCompleted: task.isCompleted ?? false
                )
            }
            completion(.success(()))
        }
    }
}
