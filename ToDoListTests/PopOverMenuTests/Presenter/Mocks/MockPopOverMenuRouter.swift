//
//  MockPopOverMenuRouter.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

final class MockPopOverMenuRouter: PopOverMenuRouterInput {
    
    private(set) var routeToDetailViewCalled = false
    private(set) var routeToShareViewCalled = false
    private(set) var dissmissCalled = false
    
    private(set) var routeToDetailViewWithTask: Task?
    private(set) var routeToShareViewWithTask: Task?
    
    func routeToDelailView(with task: Task) {
        routeToDetailViewCalled = true
        routeToDetailViewWithTask = task
    }
    
    func routeToShareView(with task: Task) {
        routeToShareViewCalled = true
        routeToShareViewWithTask = task
    }
    
    func dissmiss() {
        dissmissCalled = true
    }
}
