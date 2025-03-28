//
//  AddTaskRouter.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

import UIKit

protocol AddTaskRouterInput {
    func dismiss()
}

class AddTaskRouter: AddTaskRouterInput {
    
    weak var viewController: UIViewController?
    
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
