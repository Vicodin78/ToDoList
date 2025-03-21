//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

import UIKit

protocol TaskListRouterInput: AnyObject {
    func navigateToTaskDetail(task: Task)
    func navigateToAddTaskView()
}

final class TaskListRouter: TaskListRouterInput {
    
    weak var viewController: UIViewController?

    func navigateToTaskDetail(task: Task) {
        
    }
    
    func navigateToAddTaskView() {
        let transitionDelegate = SlideTransitioningDelegate()
        
        let addTaskVC = AddTaskBuilder.build()
        addTaskVC.transitioningDelegate = transitionDelegate
        addTaskVC.modalPresentationStyle = .custom
        
        viewController?.navigationController?.pushViewController(addTaskVC, animated: true)
    }
}
