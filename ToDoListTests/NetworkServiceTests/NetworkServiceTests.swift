//
//  NetworkServiceTests.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

final class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    var mockSession: URLSession!
    var mockCoreDataService: MockCoreDataService!
    
    override func setUp() {
        super.setUp()
        mockCoreDataService = MockCoreDataService()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: configuration)
        networkService = NetworkService()
        networkService.session = mockSession
        networkService.coreDataService = mockCoreDataService
    }
    
    override func tearDown() {
        mockCoreDataService = nil
        networkService = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testFetchTasks_Success() {
        let jsonResponse = """
        {
            "todos": [
                { "id": 1, "title": "Test Task", "completed": false }
            ]
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, jsonResponse)
        }
        
        let expectation = expectation(description: "Fetch tasks succeeds")
        
        networkService.fetchTasks { result in
            switch result {
            case .success:
                XCTAssertTrue(true, "Получение данных должно завершиться успешно")
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTasks_Failure() {
        mockCoreDataService.shouldFail = true
        
        let jsonResponse = """
        {
            "todos": [
                { "id": 1, "title": "Test Task", "completed": false }
            ]
        }
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, jsonResponse)
        }
        
        let expectation = expectation(description: "Fetch tasks failure")
        
        networkService.fetchTasks { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertFalse(error.localizedDescription.isEmpty, "Должна содержаться ошибка получения данных")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
    }
    
    func testFetchTasks_NoInternetConnection() {
        MockURLProtocol.requestHandler = { _ in throw NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil) }
        
        let expectation = expectation(description: "No internet error is thrown")
        
        networkService.fetchTasks { result in
            switch result {
            case .failure(let error as NetworkError):
                XCTAssertEqual(error.localizedDescription, NetworkError.noInternetConnection.localizedDescription, "Должна быть ошибка 'отсутствует интернет'")
            default:
                XCTFail("Expected noInternetConnection error but got success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTasks_TimedOut() {
        MockURLProtocol.requestHandler = { _ in throw NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut, userInfo: nil) }
        
        let expectation = expectation(description: "Timed Out error is thrown")
        
        networkService.fetchTasks { result in
            switch result {
            case .failure(let error as NetworkError):
                XCTAssertEqual(error.localizedDescription, NetworkError.timeout.localizedDescription, "Должна быть ошибка 'таймаут")
            default:
                XCTFail("Expected timeout error but got success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTasks_CannotConnectToHost() {
        MockURLProtocol.requestHandler = { _ in throw NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost, userInfo: nil) }
        
        let expectation = expectation(description: "Cannot Connect To Host error is thrown")
        
        networkService.fetchTasks { result in
            switch result {
            case .failure(let error as NetworkError):
                XCTAssertEqual(error.localizedDescription, NetworkError.serverUnavailable.localizedDescription, "Должна быть ошибка 'сервер недоступен")
            default:
                XCTFail("Expected serverUnavailable error but got success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTasks_CannotFindHost() {
        MockURLProtocol.requestHandler = { _ in throw NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotFindHost, userInfo: nil) }
        
        let expectation = expectation(description: "Cannot Find Host error is thrown")
        
        networkService.fetchTasks { result in
            switch result {
            case .failure(let error as NetworkError):
                XCTAssertEqual(error.localizedDescription, NetworkError.serverUnavailable.localizedDescription, "Должна быть ошибка 'Сервер недоступен'")
            default:
                XCTFail("Expected serverUnavailable error but got success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTasks_InvalidResponse() {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 503, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        
        let expectation = expectation(description: "Invalid Response error is thrown")
        
        networkService.fetchTasks { result in
            switch result {
            case .failure(let error as NetworkError):
                XCTAssertEqual(error.localizedDescription, NetworkError.invalidResponse.localizedDescription, "Должна быть ошибка invalidResponse")
            default:
                XCTFail("Expected invalidResponse error but got success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTasks_DecodingDataFailed() {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 201, httpVersion: nil, headerFields: nil)!
            return (response, nil)
        }
        
        let expectation = expectation(description: "Decoding Data Failed error is thrown")
        
        networkService.fetchTasks { result in
            switch result {
            case .failure(let error as NetworkError):
                XCTAssertEqual(error.localizedDescription, NetworkError.decodingFailed.localizedDescription, "Должна быть ошибка декодинга")
            default:
                XCTFail("Expected decodingFailed error but got success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testFetchTasks_UnknownError() {
        MockURLProtocol.requestHandler = { _ in throw NSError(domain: NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo: nil) }
        
        let expectation = expectation(description: "Unknown error is thrown")
        
        networkService.fetchTasks { result in
            switch result {
            case .failure(let error as NetworkError):
                XCTAssertFalse(error.localizedDescription.isEmpty, "Должна быть любая ошибка")
            default:
                XCTFail("Expected unknownError error but got success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
}
