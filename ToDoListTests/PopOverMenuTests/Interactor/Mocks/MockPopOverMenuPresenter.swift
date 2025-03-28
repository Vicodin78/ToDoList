//
//  MockPopOverMenuPresenter.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

final class MockPopOverMenuPresenter: PopOverMenuInteractorOutput {
    private(set) var dismissPopOverCalled = false
    
    func dissmissPopOver() {
        dismissPopOverCalled = true
    }
}
