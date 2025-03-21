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
//        let router = AddTaskRouter()
        
//        presenter.router = router
//        interactor.presenter = presenter
        viewController.presenter = presenter
//        router.viewController = viewController
        
        return viewController
    }
}
