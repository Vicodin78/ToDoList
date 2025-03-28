//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 23.03.2025.
//

import Foundation

protocol DetailTaskPresenterInput {
    func viewDidLoad()
    func saveTask(_ data: (title: String?, description: String?))
    func dismissDetailTaskView()
}

protocol DetailTaskPresenterOutput: AnyObject {
    func displayTask(_ task: Task)
    func displayError(_ error: any Error, _ popAction: @escaping (() -> Void))
}

final class TaskDetailPresenter: DetailTaskPresenterInput {
    
    weak var view: DetailTaskPresenterOutput?
    private let interactor: TaskDetailInteractorInput
    var router: DetailTaskRouterInput?
    
    private var task: Task
    
    init (task: Task, interactor: TaskDetailInteractorInput) {
        self.task = task
        self.interactor = interactor
    }
    
    func viewDidLoad() {
        view?.displayTask(task)
    }
    
    func saveTask(_ data: (title: String?, description: String?)) {
        let task = saveTaskHelper(data)
        interactor.saveTask(task: task) { [weak self] result in
            switch result {
            case .success():
                self?.dismissDetailTaskView()
            case .failure(let error):
                self?.view?.displayError(error, {
                    self?.dismissDetailTaskView()
                })
            }
        }
    }
    
    func saveTaskHelper(_ data: (title: String?, description: String?)) -> Task {
        guard let title = data.title, let description = data.description, !title.isEmpty || !description.isEmpty else {
            let error: Error = NSError(
                domain: "TaskDetailPresenter",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey : "Задача пуста. Удалить задачу?"])
            view?.displayError(error, {
                self.interactor.deleteTask(withId: self.task.id) { [weak self] result in
                    switch result {
                    case .success():
                        self?.dismissDetailTaskView()
                    case .failure(let error):
                        self?.view?.displayError(error, {
                            self?.dismissDetailTaskView()
                        })
                    }
                }
            })
            return task
        }
        task.title = title
        task.description = description
        return task
    }
    
    func dismissDetailTaskView() {
        router?.dismiss()
    }
}
