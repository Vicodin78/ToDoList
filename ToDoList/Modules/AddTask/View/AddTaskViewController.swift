//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

import UIKit

class AddTaskViewController: TaskViewController<AddTaskPresenterInput>, AddTaskPresenterOutput {
    
    override func saveTask() {
        presenter.addTask(data: self.getDataForTask())
    }
}
