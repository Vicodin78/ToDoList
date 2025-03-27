//
//  Task.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import Foundation

struct Task {
    var id: Int
    var title: String
    var description: String
    var createdAt: Date
    var isCompleted: Bool
}

struct RemoteTask: Codable {
    var id: Int?
    var title: String?
    var description: String?
    var createdAt: Date?
    var isCompleted: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, description, createdAt
        case title = "todo"
        case isCompleted = "completed"
    }
}
