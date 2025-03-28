//
//  PopOverMenuPresenterTests.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//

import XCTest
@testable import ToDoList

final class PopOverMenuPresenterTests: XCTestCase {
    
    private var sut: PopOverMenuPresenter!
    private var mockView: MockPopOverMenuView!
    private var mockInteractor: MockPopOverMenuInteractor!
    private var mockRouter: MockPopOverMenuRouter!
    private var task: Task!
    
    override func setUp() {
        super.setUp()
        task = Task(id: 1, title: "Test Task", description: "Test Description", createdAt: Date(), isCompleted: false)
        mockView = MockPopOverMenuView()
        mockInteractor = MockPopOverMenuInteractor()
        mockRouter = MockPopOverMenuRouter()
        sut = PopOverMenuPresenter(view: mockView, interactor: mockInteractor, task: task)
        sut.router = mockRouter
    }
    
    override func tearDown() {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        task = nil
        super.tearDown()
    }
    
    func testDidTapToCell_EditTask() {
        
        sut.didTapToCell(.edit)
        
        XCTAssertEqual(mockRouter.routeToDetailViewWithTask?.title, task.title, "Должен передавать задачу в роутер для DetailView")
        XCTAssertTrue(mockRouter.routeToDetailViewCalled, "Должен вызывать переход на экран детального просмотра")
    }
    
    func testDidTapToCell_ShareTask() {
        
        sut.didTapToCell(.share)
        
        XCTAssertEqual(mockRouter.routeToShareViewWithTask?.description, task.description, "Должен передавать задачу в роутер для экрана ShareView")
        XCTAssertTrue(mockRouter.routeToShareViewCalled, "Должен вызывать переход на экран 'поделиться'")
    }
    
    func testDidTapToCell_Delete() {
        let task2 = Task(id: 2, title: "Foo", description: "Play football", createdAt: Date(), isCompleted: false)
        let task3 = Task(id: 3, title: "Bob", description: "Hockey", createdAt: Date(), isCompleted: false)
        
        mockInteractor.mockTasks = [task, task2, task3]
        
        sut.didTapToCell(.delete)
        
        XCTAssertFalse(mockInteractor.mockTasks.contains(where: {$0.id == task.id}), "Метод должен удалить задачу из хранилища")
        XCTAssertTrue(mockInteractor.deleteTaskCalled, "Метод удаления должен быть вызван")
        XCTAssertEqual(mockInteractor.deleteTaskId, task.id, "Идентификатор задачи должен совпадать")
    }
    
    func testDissmissPopOver() {
        sut.dissmissPopOver()
        
        XCTAssertTrue(mockRouter.dissmissCalled, "Должен вызываться метод роутера для закрытия PopOverView")
    }
    
    func testViewDidLoad() {
        
        sut.viewDidLoad()
        
        XCTAssertTrue(mockInteractor.fetchDataCalled, "Должен быть вызван метод fetchData")
        XCTAssertEqual(mockView.displayedMenuItems.count, 3, "Должно быть передано три элемента в меню")
        XCTAssertEqual(mockView.displayedMenuItems[2].title, "Удалить", "Последним в списке должен юыть пункт Удалить")
    }
}
