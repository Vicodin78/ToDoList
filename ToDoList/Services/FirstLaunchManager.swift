//
//  FirstLaunchManager.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import Foundation

final class FirstLaunchManager {
    static private let isFirstLaunchKey = "isFirstLaunch"

    static func isFirstLaunch() -> Bool {
        !UserDefaults.standard.bool(forKey: isFirstLaunchKey)
    }
    
    static func firstLaunchCompleted() {
        UserDefaults.standard.set(true, forKey: isFirstLaunchKey)
    }
}
