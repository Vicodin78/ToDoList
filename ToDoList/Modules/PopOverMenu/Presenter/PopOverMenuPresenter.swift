//
//  PopOverMenuPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import Foundation

protocol PopOverMenuPresenterInput {
    func viewDidLoad()
}

protocol PopOverMenuPresenterOutput: AnyObject {
    func displayMenuItems(_ menuItems: [MenuItem])
}

class PopOverMenuPresenter: PopOverMenuPresenterInput {
    
    private weak var view: PopOverMenuPresenterOutput?
    private let interactor: PopOverMenuInteractorInput
//    var router: PopOverMenuRouterInput?
    
    func viewDidLoad() {
        view?.displayMenuItems(interactor.fetchData())
    }
    
    init(view: PopOverMenuPresenterOutput, interactor: PopOverMenuInteractorInput) {
        self.view = view
        self.interactor = interactor
    }
}
