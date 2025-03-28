//
//  PopOverMenuPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import Foundation

protocol PopOverMenuPresenterInput {
    func viewDidLoad()
    func didTapToCell(_ cellAction: MenuItemAction)
}

protocol PopOverMenuPresenterOutput: AnyObject {
    func displayMenuItems(_ menuItems: [MenuItem])
}

class PopOverMenuPresenter: PopOverMenuPresenterInput {
    
    private let task: Task
    
    private weak var view: PopOverMenuPresenterOutput?
    private let interactor: PopOverMenuInteractorInput
    var router: PopOverMenuRouterInput?
    
    func viewDidLoad() {
        view?.displayMenuItems(interactor.fetchData())
    }
    
    init(view: PopOverMenuPresenterOutput, interactor: PopOverMenuInteractorInput, task: Task) {
        self.view = view
        self.interactor = interactor
        self.task = task
    }
    
    func didTapToCell(_ cellAction: MenuItemAction) {
        switch cellAction {
        case .edit:
            router?.routeToDelailView(with: task)
        case .share:
            router?.routeToShareView(with: task)
        case .delete:
            interactor.deleteTask(withId: task.id)
        }
    }
}

extension PopOverMenuPresenter: PopOverMenuInteractorOutput {
    func dissmissPopOver() {
        router?.dissmiss()
    }
}
