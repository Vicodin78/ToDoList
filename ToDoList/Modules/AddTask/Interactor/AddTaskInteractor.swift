//
//  AddTaskInteractor.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

protocol AddTaskInteractorInput {
    func saveTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void)
}

final class AddTaskInteractor: AddTaskInteractorInput {
    
    func saveTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataService.shared.saveTask(task, completion: completion)
    }
}
