//
//  PopOverCellPresenterTests.swift
//  ToDoList
//
//  Created by Vicodin on 28.03.2025.
//


import XCTest
@testable import ToDoList

final class PopOverCellPresenterTests: XCTestCase {
    
    private var presenter: PopOverCellPresenter!
    private var mockView: MockPopOverCellView!
    private var mockRouter: MockPopOverRouter!
    private var task: Task!
    private var cellPosition: CGPoint!
    
    override func setUp() {
        super.setUp()
        task = .init(id: 1, title: "Test task", description: "Test description", createdAt: Date(), isCompleted: false)
        cellPosition = .init(x: 100, y: 200)
        
        mockView = MockPopOverCellView()
        mockRouter = MockPopOverRouter()
        presenter = PopOverCellPresenter(view: mockView, cellPosition: cellPosition, task: task)
        presenter.router = mockRouter
    }
    
    override func tearDown() {
        task = nil
        cellPosition = nil
        presenter = nil
        mockView = nil
        mockRouter = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        
        presenter.viewDidLoad()
        
        XCTAssertNotNil(mockView.displayedTask, "Должен передать задачу")
        XCTAssertNotNil(mockView.displayedCellPosition, "Должен передать позицию ячейки")
        
        XCTAssertEqual(mockView.displayedCellPosition, cellPosition, "Должен передать правильную позицию ячейки")
        XCTAssertEqual(mockView.displayedTask?.title, task.title, "Должен передать правильный заголовок")
    }
  
    func testDissmissPopOver() {
        
        presenter.dismiss()
        
        XCTAssertTrue(mockRouter.didDismiss, "Должен вызвать роутер для закрытия")
    }
        
}
