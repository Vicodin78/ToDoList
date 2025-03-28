//
//  NavigationControllerMockForTaskList.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

class NavigationControllerMockForTaskList: UINavigationController {
    var routerMock: ViewControllerMockForTaskList
    
    init(routerMock: ViewControllerMockForTaskList) {
        self.routerMock = routerMock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        routerMock.didPushViewController = true
    }
}
