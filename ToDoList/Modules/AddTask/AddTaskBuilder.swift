//
//  AddTaskBuilder.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import UIKit

final class AddTaskBuilder {

    static func build() -> UIViewController {
        let viewController = AddTaskViewController()
        let interactor = AddTaskInteractor()
        let presenter = AddTaskPresenter(view: viewController, interactor: interactor)
        let router = AddTaskRouter()
        let coreDataService = CoreDataService.shared
        
        viewController.presenter = presenter
        interactor.coreDataService = coreDataService
        presenter.router = router
        router.viewController = viewController
        
        return viewController
    }
}
