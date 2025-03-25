//
//  Untitled.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import UIKit

class PopOverMenuBuilder {
    static func build(_ task: Task) -> PopOverMenuTableViewController {
        let viewController = PopOverMenuTableViewController()
        let interactor = PopOverMenuInteractor()
        let presenter = PopOverMenuPresenter(view: viewController, interactor: interactor, task: task)
        let router = PopOverMenuRouter()
        
        presenter.router = router
        interactor.presenter = presenter
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
