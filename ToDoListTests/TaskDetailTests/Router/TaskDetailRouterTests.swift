//
//  TaskDetailRouterTests.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

final class TaskDetailRouterTests: XCTestCase {
    
    var router: TaskDetailRouter!
    var mockViewController: MockViewController!
    
    override func setUp() {
        super.setUp()
        router = TaskDetailRouter()
        mockViewController = MockViewController()
        router.viewController = mockViewController
    }
    
    override func tearDown() {
        router = nil
        mockViewController = nil
        super.tearDown()
    }
    
    func testDismiss_CallsPopViewController() {
        
        router.dismiss()
        
        XCTAssertTrue(mockViewController.mockNavController.didPopViewController, "Метод popViewController(animated:) должен быть вызван")
    }
}

final class MockNavigationController: UINavigationController {
    var didPopViewController = false
    
    override func popViewController(animated: Bool) -> UIViewController? {
        didPopViewController = true
        return super.popViewController(animated: animated)
    }
}

final class MockViewController: UIViewController {
    let mockNavController = MockNavigationController()
    
    override var navigationController: UINavigationController? {
        return mockNavController
    }
}
