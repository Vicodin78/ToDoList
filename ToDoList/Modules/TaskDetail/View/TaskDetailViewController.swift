//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by Vicodin on 23.03.2025.
//

import UIKit

class TaskDetailViewController: TaskViewController<DetailTaskPresenterInput>, DetailTaskPresenterOutput {    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func saveTask() {
        presenter.saveTask(self.getDataForTask())
    }
}
