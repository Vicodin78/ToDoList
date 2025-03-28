//
//  TaskDetailPresenterTests.swift
//  ToDoList
//
//  Created by Vicodin on 27.03.2025.
//

import XCTest
@testable import ToDoList

final class TaskDetailPresenterTests: XCTestCase {
    
    private var presenter: TaskDetailPresenter!
    private var mockView: MockDetailTaskView!
    private var mockInteractor: MockTaskDetailInteractor!
    private var mockRouter: MockDetailTaskRouter!
    private var task: Task!
    
    override func setUp() {
        super.setUp()
        task = Task(id: Int.random(in: 0..<1000), title: "Test Task", description: "Test Description", createdAt: Date(), isCompleted: false)
        mockView = MockDetailTaskView()
        mockInteractor = MockTaskDetailInteractor()
        mockRouter = MockDetailTaskRouter()
        presenter = TaskDetailPresenter(task: task, interactor: mockInteractor)
        presenter.view = mockView
        presenter.router = mockRouter
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        task = nil
        super.tearDown()
    }
    
    func testViewDidLoad_ShouldDisplayTask() {
        presenter.viewDidLoad()
        
        XCTAssertEqual(mockView.displayedTask?.title, task.title, "Должен передавать задачу во view")
    }
    
    func testSaveTask_ShouldCallInteractorWithUpdatedTask() {
        let updatedData = (title: "Updated Title", description: "Updated Description")
        
        presenter.saveTask(updatedData)
        
        XCTAssertEqual(mockInteractor.savedTask?.title, updatedData.title, "Должен обновить заголовок")
        XCTAssertEqual(mockInteractor.savedTask?.description, updatedData.description, "Должен обновить описание")
    }

    func testSaveTask_OnSuccess_ShouldDismissView() {
        presenter.saveTask((title: "New Task", description: "New Description"))
        
        XCTAssertTrue(mockRouter.didDismiss, "После успешного сохранения должен закрыть экран")
    }

    func testSaveTask_OnFailure_ShouldShowError() {
        let error = NSError(domain: "TestError", code: 500, userInfo: nil)
        mockInteractor.saveResult = .failure(error)
        
        presenter.saveTask((title: "Fail Task", description: "This will fail"))
        
        XCTAssertEqual(mockView.displayedError?.0.localizedDescription, error.localizedDescription, "Должен показывать ошибку")
    }
    
    func testSaveEmptyTask_ShouldShowError() {
        presenter.saveTask((title: nil, description: nil))

        XCTAssertNotNil(mockView.displayedError, "Должен отобразить ошибку")
    }

    func testDismissDetailTaskView_ShouldCallRouterDismiss() {
        presenter.dismissDetailTaskView()
        
        XCTAssertTrue(mockRouter.didDismiss, "Метод dismissDetailTaskView должен закрывать экран через router")
    }
}
