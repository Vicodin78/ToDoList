//
//  MockPopOverMenuInteractor.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

final class MockPopOverMenuInteractor: PopOverMenuInteractorInput {
    
    var mockTasks: [Task] = []
    private(set) var deleteTaskId: Int?
    private(set) var deleteTaskCalled = false
    
    private(set) var fetchDataCalled = false
    
    private let menuItems: [MenuItem] = [
        .init(title: "Редактировать", icon: "edit", action: .edit),
        .init(title: "Поделиться", icon: "export", action: .share),
        .init(title: "Удалить", icon: "trash", action: .delete)
    ]
    
    func fetchData() -> [MenuItem] {
        fetchDataCalled = true
        return menuItems
    }
    
    func deleteTask(withId taskId: Int) {
        deleteTaskCalled = true
        deleteTaskId = taskId
        mockTasks = mockTasks.filter { $0.id != taskId }
    }
}
