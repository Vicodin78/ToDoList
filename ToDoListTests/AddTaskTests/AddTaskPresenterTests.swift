//
//  AddTaskPresenterTests.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class AddTaskPresenterTests: XCTestCase {
    
    private var presenter: AddTaskPresenter!
    private var mockView: MockAddTaskView!
    private var mockInteractor: MockAddTaskInteractor!
    private var mockRouter: MockAddTaskRouter!
    
    override func setUp() {
        super.setUp()
        mockView = MockAddTaskView()
        mockInteractor = MockAddTaskInteractor()
        mockRouter = MockAddTaskRouter()
        presenter = AddTaskPresenter(view: mockView, interactor: mockInteractor)
        presenter.router = mockRouter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testAddTask_WithValidData_ShouldCallInteractor() {
        let data = (title: "New Task", description: "Task description")

        presenter.addTask(data: data)
        
        XCTAssertEqual(mockInteractor.savedTask?.title, data.title, "Должен передать правильный заголовок")
        XCTAssertEqual(mockInteractor.savedTask?.description, data.description, "Должен передать правильное описание")
    }
    
    func testAddTask_OnSuccess_ShouldDismissView() {
        presenter.addTask(data: (title: "New Task", description: "Description"))

        XCTAssertTrue(mockRouter.didDismiss, "После успешного добавления должен закрыть экран")
    }

    func testAddTask_WithEmptyData_ShouldShowError() {
        presenter.addTask(data: (title: nil, description: nil))

        XCTAssertNotNil(mockView.displayedError, "Должен показывать ошибку при пустых данных")
    }
    
    func testAddTask_WithEmptyData_ShouldDissmissView() {
        presenter.addTask(data: (title: nil, description: nil))

        XCTAssertTrue(mockRouter.didDismiss, "Должен закрыть экран при пустых данных и согласии пользователя")
    }

    func testAddTask_OnFailure_ShouldShowError() {
        let error = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockInteractor.saveResult = .failure(error)

        presenter.addTask(data: (title: "Fail Task", description: "Will fail"))

        XCTAssertEqual(mockView.displayedError?.0.localizedDescription, error.localizedDescription, "Должен показывать ошибку сохранения")
    }
    
    func testAddTask_OnFailure_ShouldDissmissView() {
        let error = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockInteractor.saveResult = .failure(error)

        presenter.addTask(data: (title: "Fail Task", description: "Will fail"))

        XCTAssertTrue(mockRouter.didDismiss, "Должен закрыть экран при ошибке сохранения данных и согласии пользователя")
    }
    
    func testDismissAddTaskView_ShouldCallRouterDismiss() {
        presenter.dismissAddTaskView()
        
        XCTAssertTrue(mockRouter.didDismiss, "Метод dismissAddTaskView должен закрывать экран через router")
    }
}
