//
//  TaskDetailBuilder.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import UIKit

final class TaskDetailBuilder {
    static func build(task: Task) -> UIViewController {
        let view = TaskDetailViewController()
        let interactor = TaskDetailInteractor()
        let presenter = TaskDetailPresenter(task: task, interactor: interactor)
        let router = TaskDetailRouter()
        let coreDataService = CoreDataService.shared
        
        view.presenter = presenter
        interactor.coreDataService = coreDataService
        presenter.view = view
        presenter.router = router
        router.viewController = view

        return view
    }
}
