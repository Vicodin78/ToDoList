//
//  FirstLaunchManager.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import Foundation

protocol FirstLaunchManagerProtocol {
    func isFirstLaunch() -> Bool
}

final class FirstLaunchManager: FirstLaunchManagerProtocol {
    private let isFirstLaunchKey = "isFirstLaunch"

    func isFirstLaunch() -> Bool {
        !UserDefaults.standard.bool(forKey: isFirstLaunchKey)
    }
    
    func firstLaunchCompleted() {
        UserDefaults.standard.set(true, forKey: isFirstLaunchKey)
    }
}
