//
//  PopOverMenuInteractor.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import Foundation

protocol PopOverMenuInteractorInput {
    func fetchData() -> [MenuItem]
    func deleteTask(withId taskId: Int)
}

protocol PopOverMenuInteractorOutput: AnyObject {
    func dissmissPopOver()
}

class PopOverMenuInteractor: PopOverMenuInteractorInput {
    
    weak var presenter: PopOverMenuInteractorOutput?
    
    private let menuItems: [MenuItem] = [
        .init(title: "Редактировать", icon: "edit", action: .edit),
        .init(title: "Поделиться", icon: "export", action: .share),
        .init(title: "Удалить", icon: "trash", action: .delete)
    ]
    
    func fetchData() -> [MenuItem] {
        return menuItems
    }
    
    func deleteTask(withId taskId: Int) {
        CoreDataService.shared.deleteTask(taskId) { result in
            switch result {
            case .success(_):
                self.presenter?.dissmissPopOver()
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
