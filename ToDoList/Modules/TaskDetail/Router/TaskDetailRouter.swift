//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created by Vicodin on 23.03.2025.
//

import UIKit

protocol DetailTaskRouterInput: AnyObject {
    func dismiss()
}

final class TaskDetailRouter: DetailTaskRouterInput {
    
    weak var viewController: UIViewController?
    
    func dismiss() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
