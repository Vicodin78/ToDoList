//
//  PopOverCellPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import Foundation

protocol PopOverCellPresenterInput: PopOverMenuDelegate {
    func viewDidLoad()
}

protocol PopOverCellPresenterOutput: AnyObject {
    func displayCell(task: Task, cellPosition: CGPoint)
}

class PopOverCellPresenter: PopOverCellPresenterInput {
    
    weak var view: PopOverCellPresenterOutput?
//    private let interactor: PopOverCellInteractorInput
    var router: PopOverCellRouterInput?
    
    private let cellPosition: CGPoint
    private let task: Task
    
    init(view: PopOverCellPresenterOutput, cellPosition: CGPoint, task: Task) {
        self.view = view
        self.cellPosition = cellPosition
        self.task = task
    }
    
    func viewDidLoad() {
        view?.displayCell(task: task, cellPosition: cellPosition)
    }
    
    func dismiss() {
        router?.dismiss()
    }
}
