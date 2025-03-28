//
//  PopOverMenuRouterTests.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

class ViewControllerMock: UIViewController {
    var presentCalled = false
    var dismissCalled = false
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalled = true
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCalled = true
    }
}

class PopOverMenuRouterTests: XCTestCase {
    
    var router: PopOverMenuRouter!
    var viewControllerMock: ViewControllerMock!
    
    override func setUp() {
        super.setUp()
        viewControllerMock = ViewControllerMock()
        router = PopOverMenuRouter()
        router.viewController = viewControllerMock
    }
    
    override func tearDown() {
        router = nil
        viewControllerMock = nil
        super.tearDown()
    }
    
    func testRouteToDetailView_PresentsDetailView() {
        let task = Task(id: 1, title: "Test Task", description: "Test Description", createdAt: Date(), isCompleted: false)
        
        router.routeToDelailView(with: task)
        
        XCTAssertTrue(viewControllerMock.presentCalled, "Должен быть вызван метод present у viewController и передан в него DelailViewController")
    }
    
    func testRouteToShareView_presentsActivityViewController() {
        let task = Task(id: 1, title: "Test Task", description: "Test Description", createdAt: Date(), isCompleted: false)
        
        router.routeToShareView(with: task)
        
        XCTAssertTrue(viewControllerMock.presentCalled, "Должен быть вызван метод present у viewController и передан в него ActivityViewController")
    }
    
    func testDismiss_dismissesViewController() {
        router.dissmiss()
        
        XCTAssertTrue(viewControllerMock.dismissCalled, "Должен быть вызван метод dismiss")
    }
}


