//
//  TaskListInteactor.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import Foundation

protocol TaskListInteractorInput {
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    func saveTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(withId taskId: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TaskListInteractor: TaskListInteractorInput {

    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        CoreDataService.shared.fetchTasks { result in
            completion(result)
        }
    }

    func saveTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataService.shared.saveTask(task, completion: completion)
    }

    func deleteTask(withId taskId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataService.shared.deleteTask(taskId, completion: completion)
    }
}
