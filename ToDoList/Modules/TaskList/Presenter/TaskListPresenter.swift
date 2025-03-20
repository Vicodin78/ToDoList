//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import Foundation

protocol TaskListPresenterInput {
    func viewDidLoad()
    func addTask(_ task: Task)
    func deleteTask(taskId: Int)
}

protocol TaskListPresenterOutput: AnyObject {
    func displayTasks(_ tasks: [Task])
    func displayError(_ error: Error)
}

final class TaskListPresenter: TaskListPresenterInput {

    weak var view: TaskListPresenterOutput?
    private let interactor: TaskListInteractorInput
    weak var router: TaskListRouterInput?

    init(view: TaskListPresenterOutput, interactor: TaskListInteractorInput) {
        self.view = view
        self.interactor = interactor
    }

    func viewDidLoad() {
        interactor.fetchTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.view?.displayTasks(tasks)
            case .failure(let error):
                self?.view?.displayError(error)
            }
        }
    }

    func addTask(_ task: Task) {
        interactor.saveTask(task: task) { [weak self] result in
            switch result {
            case .success():
                self?.viewDidLoad()
            case .failure(let error):
                self?.view?.displayError(error)
            }
        }
    }

    func deleteTask(taskId: Int) {
        interactor.deleteTask(withId: taskId) { [weak self] result in
            switch result {
            case .success():
                self?.viewDidLoad()
            case .failure(let error):
                self?.view?.displayError(error)
            }
        }
    }
}
