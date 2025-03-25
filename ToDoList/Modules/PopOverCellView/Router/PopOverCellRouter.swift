//
//  PopOverCellRouter.swift
//  ToDoList
//
//  Created by Vicodin on 25.03.2025.
//

import UIKit

protocol PopOverCellRouterInput {
    func dismiss()
}

class PopOverCellRouter: PopOverCellRouterInput {
    
    weak var viewController: UIViewController?
    
    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
