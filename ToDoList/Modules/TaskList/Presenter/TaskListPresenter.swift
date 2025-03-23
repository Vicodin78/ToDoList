//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import Foundation

protocol TaskListPresenterInput {
    func viewDidLoad()
    func searchTasks(with query: String)
    func updateTask(_ task: Task)
    func deleteTask(taskId: Int, completion: @escaping (Bool) -> Void)
    func didTapAddTaskScreen()
    func didTadDetailTaskScreen(with task: Task)
}

protocol TaskListPresenterOutput: AnyObject {
    func displayTasks(_ tasks: [Task])
    func displayError(_ error: Error)
}

final class TaskListPresenter: TaskListPresenterInput {

    weak var view: TaskListPresenterOutput?
    private let interactor: TaskListInteractorInput
    var router: TaskListRouterInput?
    
    private var allTasks: [Task] = [] // Список всех задач
    private var filteredTasks: [Task] = [] // Отфильтрованные задачи
    private var isSearching: Bool = false

    init(view: TaskListPresenterOutput, interactor: TaskListInteractorInput) {
        self.view = view
        self.interactor = interactor
    }

    func viewDidLoad() {
        interactor.fetchTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.allTasks = tasks
                self?.view?.displayTasks(tasks)
            case .failure(let error):
                self?.view?.displayError(error)
            }
        }
    }
    
    func searchTasks(with query: String) {
        isSearching = !query.isEmpty
        interactor.filterTasks(with: query)
    }

    func updateTask(_ task: Task) {
        interactor.saveTask(task: task) { [weak self] result in
            switch result {
            case .success():
                self?.viewDidLoad()
            case .failure(let error):
                self?.view?.displayError(error)
            }
        }
    }

    func deleteTask(taskId: Int, completion: @escaping (Bool) -> Void) {
        interactor.deleteTask(withId: taskId) { [weak self] result in
            switch result {
            case .success():
                completion(true)
                self?.viewDidLoad()
            case .failure(let error):
                self?.view?.displayError(error)
            }
        }
    }
    
    func didTapAddTaskScreen() {
        router?.navigateToAddTaskView()
    }
    
    func didTadDetailTaskScreen(with task: Task) {
        router?.navigateToTaskDetail(task: task)
    }
}

// MARK: - TaskListInteractorOutput
extension TaskListPresenter: TaskListInteractorOutput {
    func didFilterTasks(_ tasks: [Task]) {
        self.filteredTasks = tasks
        view?.displayTasks(isSearching ? filteredTasks : allTasks)
    }
    
    func displayError(_ error: any Error) {
        view?.displayError(error)
    }
}
