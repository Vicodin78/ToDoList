//
//  NetworkService.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import Foundation

struct Tasks: Codable {
    let tasks: [RemoteTask]
    
    enum CodingKeys: String, CodingKey {
        case tasks = "todos"
    }
}

enum NetworkError: Error {
    case noInternetConnection
    case serverUnavailable
    case timeout
    case invalidResponse
    case invalidURL
    case decodingFailed
    case isRequestInProgress
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .noInternetConnection:
            return "Отсутствует подключение к интернету"
        case .serverUnavailable:
            return "Сервер недоступен. Попробуйте позже."
        case .timeout:
            return "Превышено время ожидания ответа от сервера"
        case .invalidResponse:
            return "Некорректный ответ от сервера"
        case .invalidURL:
            return "Некорректный адрес сервера"
        case .decodingFailed:
            return "Ошибка обработки данных"
        case .isRequestInProgress:
            return "Запрос уже выполняется"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

protocol NetworkServiceProtocol {
    func fetchTasks(completion: @escaping (Result<Void, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private var isRequestInProgress = false
    
    private let session = URLSession.shared
    private let urlString = "https://dummyjson.com/todos"
    
    func fetchTasks(completion: @escaping (Result<Void, Error>) -> Void) {
        guard !isRequestInProgress else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.isRequestInProgress))
            }
            return
        }
        
        isRequestInProgress = true
        guard let url = URL(string: self.urlString) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.invalidResponse))
            }
            isRequestInProgress = false
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let task = self.session.dataTask(with: request) { [weak self] data, response, error in
            defer { self?.isRequestInProgress = false }
            
            if let error = error as NSError? {
                DispatchQueue.main.async {
                    completion(.failure(self?.mapError(error) ?? error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let tasks = try decoder.decode(Tasks.self, from: data)
                CoreDataService.shared.saveTasks(tasks.tasks) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingFailed))
                }
            }
        }
        task.resume()
    }
    
    private func mapError(_ error: NSError) -> NetworkError {
        switch error.code {
        case NSURLErrorNotConnectedToInternet:
            return .noInternetConnection
        case NSURLErrorTimedOut:
            return .timeout
        case NSURLErrorCannotConnectToHost, NSURLErrorCannotFindHost:
            return .serverUnavailable
        default:
            return .unknown(error)
        }
    }
}
