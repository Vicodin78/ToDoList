//
//  ViewControllerMockForTaskList.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

class ViewControllerMockForTaskList: UIViewController {
    var didPushViewController = false
    var didPresentViewController = false
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        didPresentViewController = true
    }
    
    override var navigationController: UINavigationController? {
        return NavigationControllerMockForTaskList(routerMock: self)
    }
}
