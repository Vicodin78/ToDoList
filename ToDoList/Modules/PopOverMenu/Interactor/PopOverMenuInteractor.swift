//
//  PopOverMenuInteractor.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import Foundation

protocol PopOverMenuInteractorInput {
    func fetchData() -> [MenuItem]
}

class PopOverMenuInteractor: PopOverMenuInteractorInput {
    
    private let menuItems: [MenuItem] = [
        .init(title: "Редактировать", icon: "edit", action: .edit),
        .init(title: "Поделиться", icon: "export", action: .share),
        .init(title: "Удалить", icon: "trash", action: .delete)
    ]
    
    func fetchData() -> [MenuItem] {
        return menuItems
    }
}
