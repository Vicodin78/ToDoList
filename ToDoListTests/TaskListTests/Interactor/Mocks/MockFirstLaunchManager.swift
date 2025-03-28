//
//  MockFirstLaunchManager.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

final class MockFirstLaunchManager: FirstLaunchManagerProtocol {
    var isFirstLaunchCalled = false
    
    var isFirstLoad = true
    
    func isFirstLaunch() -> Bool {
        isFirstLaunchCalled = true
        return isFirstLoad
    }
    
    func firstLaunchCompleted() {
        isFirstLoad = false
    }
}
