//
//  AddTaskPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

import Foundation

protocol AddTaskPresenterInput {
    func viewDidLoad()
    func addTask(_ task: Task)
    func dismisAddTaskScreen()
}

protocol AddTaskPresenterOutput: AnyObject {
    func displayError(_ error: Error)
}

final class AddTaskPresenter: AddTaskPresenterInput {

    weak var view: AddTaskPresenterOutput?
    private let interactor: AddTaskInteractorInput
//    var router: AddTaskRouterInput?

    init(view: AddTaskPresenterOutput, interactor: AddTaskInteractorInput) {
        self.view = view
        self.interactor = interactor
    }

    func viewDidLoad() {
//        interactor.fetchTasks { [weak self] result in
//            switch result {
//            case .success(let tasks):
//                self?.allTasks = tasks
//                self?.view?.displayTasks(tasks)
//            case .failure(let error):
//                self?.view?.displayError(error)
//            }
//        }
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
    
    func dismisAddTaskScreen() {
//        router?.navigateToAddTaskView()
    }
}
