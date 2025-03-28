//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import Foundation

protocol TaskListPresenterInput {
    func viewDidLoad()
    func searchTasks(with query: String, completion: (() -> Void)?)
    func updateTask(_ task: Task)
    func deleteTask(taskId: Int, completion: @escaping (Bool) -> Void)
    func didTapAddTaskScreen()
    func didTadDetailTaskScreen(with task: Task)
    func didLongTapTask(with task: Task, at cellPosition: CGPoint)
}

protocol TaskListPresenterOutput: AnyObject {
    func displayTasks(_ tasks: [Task], _ notCompletedTasksCount: Int)
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
    
    private func checkNotCompletedTasksCount(_ tasks: [Task]) -> Int {
        tasks.filter {$0.isCompleted == false}.count
    }

    func viewDidLoad() {
        interactor.fetchTasks { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let tasks):
                self.allTasks = tasks
                self.view?.displayTasks(tasks, self.checkNotCompletedTasksCount(tasks))
            case .failure(let error):
                self.view?.displayError(error)
            }
        }
    }
    
    func searchTasks(with query: String, completion: (() -> Void)?) {
        isSearching = !query.isEmpty
        interactor.filterTasks(with: query, completion: completion)
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
                self?.viewDidLoad()
                completion(true)
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
    
    func didLongTapTask(with task: Task, at cellPosition: CGPoint) {
        router?.navigateToPopOverCell(with: task, at: cellPosition)
    }
}

// MARK: - TaskListInteractorOutput
extension TaskListPresenter: TaskListInteractorOutput {
    func didFilterTasks(_ tasks: [Task]) {
        self.filteredTasks = tasks
        if isSearching {
            view?.displayTasks(filteredTasks, checkNotCompletedTasksCount(filteredTasks))
        } else {
            view?.displayTasks(allTasks, checkNotCompletedTasksCount(allTasks))
        }
    }
    
    func displayError(_ error: any Error) {
        view?.displayError(error)
    }
}
