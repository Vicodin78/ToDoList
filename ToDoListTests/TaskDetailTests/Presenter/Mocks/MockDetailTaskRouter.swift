//
//  MockDetailTaskRouter.swift
//  ToDoListTests
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class MockDetailTaskRouter: DetailTaskRouterInput {
    private(set) var didDismiss = false

    func dismiss() {
        didDismiss = true
    }
}
