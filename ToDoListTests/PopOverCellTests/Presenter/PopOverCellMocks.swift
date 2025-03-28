//
//  Mocks.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//


import XCTest
@testable import ToDoList

final class MockPopOverCellView: PopOverCellPresenterOutput {
    private(set) var displayedTask: Task?
    private(set) var displayedCellPosition: CGPoint?
    
    
    func displayCell(task: Task, cellPosition: CGPoint) {
        displayedTask = task
        displayedCellPosition = cellPosition
    }
}

final class MockPopOverRouter: PopOverCellRouterInput {
    private(set) var didDismiss = false
    
    func dismiss() {
        didDismiss = true
    }
}
