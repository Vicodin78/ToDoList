//
//  MockTaskDetailInteractor.swift
//  ToDoListTests
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class MockTaskDetailInteractor: TaskDetailInteractorInput {
    
    private(set) var savedTask: Task?
    private(set) var deletedTaskId: Int?
    var saveResult: Result<Void, Error> = .success(())
    var deleteResult: Result<Void, Error> = .success(())

    func saveTask(task: Task, completion: @escaping (Result<Void, any Error>) -> Void) {
        savedTask = task
        completion(saveResult)
    }

    func deleteTask(withId taskId: Int, completion: @escaping (Result<Void, any Error>) -> Void) {
        deletedTaskId = taskId
        completion(deleteResult)
    }
}
