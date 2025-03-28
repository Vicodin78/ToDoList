//
//  MockNetworkService.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class MockNetworkService: NetworkServiceProtocol {
    
    var shouldFail = false
    
    func fetchTasks(completion: @escaping (Result<Void, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "NetworkError", code: 500, userInfo: nil)))
        } else {
            completion(.success(()))
        }
    }
}
