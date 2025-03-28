//
//  AddTaskPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

import Foundation

protocol AddTaskPresenterInput {
    func viewDidLoad()
    func addTask(data: (title: String?, description: String?))
    func dismissAddTaskView()
}

protocol AddTaskPresenterOutput: AnyObject {
    func displayError(_ error: any Error, _ popAction: @escaping (() -> Void))
}

final class AddTaskPresenter: AddTaskPresenterInput {

    weak var view: AddTaskPresenterOutput?
    private let interactor: AddTaskInteractorInput
    var router: AddTaskRouterInput?

    init(view: AddTaskPresenterOutput, interactor: AddTaskInteractorInput) {
        self.view = view
        self.interactor = interactor
    }

    func viewDidLoad() {
        //Возможно будет нужен в будущем
    }

    func addTask(data: (title: String?, description: String?)) {
        guard let task = addTaskHelper(data: data) else {
            let error: Error = NSError(
                domain: "AddTaskPresenter",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey : "Задача пуста. Выйти без сохранения?"])
            view?.displayError(error, {
                self.dismissAddTaskView()
            })
            return
        }
        interactor.saveTask(task: task) { [weak self] result in
            switch result {
            case .success():
                self?.dismissAddTaskView()
            case .failure(let error):
                self?.view?.displayError(error, {
                    self?.dismissAddTaskView()
                })
            }
        }
    }
    
    private func addTaskHelper(data: (title: String?, description: String?)) -> Task? {
        let date = Date()
        let defaultName = "Задача от \(DateFormatter.formatDateToString(date))"
        guard let title = data.title, let description = data.description, !title.isEmpty || !description.isEmpty else {
            return nil
        }
        let task = Task(
            id: 0,
            title: !title.isEmpty ? title : defaultName,
            description: description,
            createdAt: date,
            isCompleted: false
        )
        return task
    }
    
    func dismissAddTaskView() {
        router?.dismiss()
    }
}
