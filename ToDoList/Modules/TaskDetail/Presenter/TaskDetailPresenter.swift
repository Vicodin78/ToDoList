//
//  TaskDetailPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 23.03.2025.
//

protocol DetailTaskPresenterInput {
    func viewDidLoad()
}

protocol DetailTaskPresenterOutput: AnyObject {
    func displayTask(_ task: Task)
}

final class TaskDetailPresenter: DetailTaskPresenterInput {
    
    weak var view: DetailTaskPresenterOutput?
//    private let interactor: DetailTaskInteractorInput
    var router: DetailTaskRouterInput?
    
    let task: Task
    
    init (task: Task) {
        self.task = task
    }
    
    func viewDidLoad() {
        view?.displayTask(task)
    }
}
