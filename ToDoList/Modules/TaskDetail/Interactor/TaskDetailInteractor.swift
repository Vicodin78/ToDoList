//
//  DetailTaskInteractor.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import Foundation

protocol TaskDetailInteractorInput {
    func saveTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTask(withId taskId: Int, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TaskDetailInteractor: TaskListInteractor, TaskDetailInteractorInput {
    
}
