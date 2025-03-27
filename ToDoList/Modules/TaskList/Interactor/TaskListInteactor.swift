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
    func filterTasks(with query: String)
}

protocol TaskListInteractorOutput: AnyObject {
    func didFilterTasks(_ tasks: [Task])
    func displayError(_ error: Error)
}

class TaskListInteractor: TaskListInteractorInput {
    
    weak var presenter: TaskListInteractorOutput?
    var networkService: NetworkServiceProtocol?
    
    func filterTasks(with query: String) {
        self.fetchTasks { result in
            DispatchQueue.global(qos: .userInitiated).async {
                switch result {
                case .success(let tasks):
                    let filtered = tasks.filter { task in
                        let titleMatch = task.title.lowercased().contains(query.lowercased())
                        let descriptionMatch = task.description.lowercased().contains(query.lowercased())
                        let createdAtMatch = DateParser.parseDate(task: task, with: query)
                        
                        return titleMatch || descriptionMatch || createdAtMatch
                    }
                    
                    DispatchQueue.main.async {
                        self.presenter?.didFilterTasks(filtered)
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.presenter?.displayError(failure)
                    }
                    
                }
            }
        }
    }
    
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        if FirstLaunchManager.isFirstLaunch() {
            networkService?.fetchTasks(completion: { result in
                switch result {
                case .success():
                    CoreDataService.shared.fetchTasks { completion($0) }
                case .failure(let error):
                    self.presenter?.displayError(error)
                }
            })
        } else {
            CoreDataService.shared.fetchTasks { completion($0) }
        }
    }
    
    func saveTask(task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataService.shared.saveTask(task, completion: completion)
    }
    
    func deleteTask(withId taskId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        CoreDataService.shared.deleteTask(taskId, completion: completion)
    }
}
