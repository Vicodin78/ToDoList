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
        let presenter = TaskDetailPresenter(task: task)
//            let interactor = TaskDetailInteractor()
        let router = TaskDetailRouter()

        view.presenter = presenter
        presenter.view = view
//            presenter.interactor = interactor
        presenter.router = router

        return view
    }
}
