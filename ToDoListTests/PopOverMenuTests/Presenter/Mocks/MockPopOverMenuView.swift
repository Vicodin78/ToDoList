//
//  MockPopOverMenuView.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

final class MockPopOverMenuView: PopOverMenuPresenterOutput {
    
    private(set) var displayedMenuItems: [MenuItem] = []
    
    func displayMenuItems(_ menuItems: [MenuItem]) {
        displayedMenuItems = menuItems
    }
}
