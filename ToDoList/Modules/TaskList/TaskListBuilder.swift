//
//  TaskListBuilder.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import UIKit

final class TaskListBuilder {

    static func build() -> UIViewController {
        let viewController = TaskListViewController()
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter(view: viewController, interactor: interactor)
        let router = TaskListRouter()
        let networkService = NetworkService()
        let coreDataService = CoreDataService.shared
        
        presenter.router = router
        interactor.presenter = presenter
        interactor.networkService = networkService
        interactor.coreDataService = coreDataService
        viewController.presenter = presenter
        router.viewController = viewController
        
        return UINavigationController(rootViewController: viewController)
    }
}
