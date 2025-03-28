//
//  TestCoreDataService.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
import CoreData
@testable import ToDoList

class TestCoreDataService: CoreDataService {
    
    override init(persistentContainer: NSPersistentContainer = NSPersistentContainer(name: "TaskModel")) {
        let persistentContainer: NSPersistentContainer = {
            let container = persistentContainer
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
            return container
        }()
        
        super.init(persistentContainer: persistentContainer)
    }
}
