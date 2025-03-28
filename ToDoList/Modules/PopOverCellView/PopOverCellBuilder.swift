//
//  PopOverCellBuilder.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import UIKit

class PopOverCellBuilder {
    
    static func build(cellPosition: CGPoint, task: Task, completion forPushToEditView: @escaping (_ task: Task) -> Void) -> UIViewController {
        let viewController = PopOverCellViewController(completion: forPushToEditView)
        let presenter = PopOverCellPresenter(
            view: viewController,
            cellPosition: cellPosition,
            task: task
        )
        let router = PopOverCellRouter()
        
        presenter.router = router
        viewController.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
    
}
