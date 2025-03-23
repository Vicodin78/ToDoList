//
//  TaskDetailRouter.swift
//  ToDoList
//
//  Created by Vicodin on 23.03.2025.
//

import UIKit

protocol DetailTaskRouterInput: AnyObject {
    
}

final class TaskDetailRouter: DetailTaskRouterInput {
    
    static func createModule(with task: Task) -> UIViewController {
        TaskDetailBuilder.build(task: task)
    }
}
