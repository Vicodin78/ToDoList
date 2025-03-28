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
    func navigateToPopOverCell(with task: Task, at cellPosition: CGPoint)
}

final class TaskListRouter: TaskListRouterInput {
    
    let customTransitioningDelegate = CustomTransitioningDelegate()
    
    weak var viewController: UIViewController?

    func navigateToTaskDetail(task: Task) {
        let detailVC = TaskDetailBuilder.build(task: task)
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func navigateToAddTaskView() {
        let transitionDelegate = SlideTransitioningDelegate()
        
        let addTaskVC = AddTaskBuilder.build()
        addTaskVC.transitioningDelegate = transitionDelegate
        addTaskVC.modalPresentationStyle = .custom
        
        viewController?.navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    func navigateToPopOverCell(with task: Task, at cellPosition: CGPoint) {
        let popOverCell = PopOverCellBuilder.build(cellPosition: cellPosition, task: task)
        
        popOverCell.modalPresentationStyle = .custom
        popOverCell.transitioningDelegate = customTransitioningDelegate
        
        viewController?.present(popOverCell, animated: true)
    }
}
