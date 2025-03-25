//
//  PopOverMenuRouter.swift
//  ToDoList
//
//  Created by Vicodin on 25.03.2025.
//

import UIKit

protocol PopOverMenuRouterInput {
    func routeToDelailView(with task: Task)
    func routeToShareView(with task: Task)
    func dissmiss()
}


class PopOverMenuRouter: PopOverMenuRouterInput {
    
    weak var viewController: UIViewController?
    
    func routeToDelailView(with task: Task) {
        let detailView = TaskDetailBuilder.build(task: task)
        viewController?.present(detailView, animated: true)
    }
    
    func routeToShareView(with task: Task) {
        guard let viewController else { return }
        
        let textToShare =
        """
        \(task.title)
        
        \(task.description)
        
        Дата создания: \(DateFormatter.formatDateToString(task.createdAt))
        
        Статус: \(task.isCompleted ? "Выполнено" : "Не выполнено")
        """
        
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.addToReadingList]
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(activityViewController, animated: true)
    }
    
    func dissmiss() {
        viewController?.dismiss(animated: true)
    }
}
