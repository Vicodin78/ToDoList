//
//  Untitled.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import UIKit

class PopOverMenuBuilder {
    static func build(_ task: Task, completion forPushToEditView: @escaping (_ task: Task) -> Void) -> PopOverMenuTableViewController {
        let viewController = PopOverMenuTableViewController()
        let interactor = PopOverMenuInteractor()
        let presenter = PopOverMenuPresenter(view: viewController, interactor: interactor, task: task)
        let router = PopOverMenuRouter(completion: forPushToEditView)
        let coreDataService = CoreDataService.shared
        
        presenter.router = router
        interactor.presenter = presenter
        interactor.coreDataService = coreDataService
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
