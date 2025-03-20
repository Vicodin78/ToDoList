//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

import UIKit

protocol TaskListRouterInput: AnyObject {
    func navigateToTaskDetail(task: Task)
}

final class TaskListRouter: TaskListRouterInput {
    
    weak var viewController: UIViewController?

    func navigateToTaskDetail(task: Task) {
        // Пример перехода на экран редактирования задачи
//        let taskDetailVC = TaskDetailViewController()
//        viewController?.navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}
