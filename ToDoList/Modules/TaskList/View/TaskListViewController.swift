//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import UIKit

final class TaskListViewController: UIViewController, TaskListPresenterOutput {

    var presenter: TaskListPresenterInput!
    private var tasks: [Task] = []
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "SFProDisplay-Bold", size: 34)
        $0.textColor = .whiteF4
        $0.text = "Задачи"
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private lazy var searchView: SearchView = {
        $0.delegate = self
        return $0
    }(SearchView())

    private lazy var tableView: UITableView = {
        let tbView = UITableView(frame: .zero, style: .plain)
        tbView.translatesAutoresizingMaskIntoConstraints = false
        tbView.dataSource = self
//        tbView.delegate = self
        tbView.register(TaskListTableViewCell.self, forCellReuseIdentifier: TaskListTableViewCell.identifier)
        tbView.backgroundColor = .clear
        tbView.separatorInset = .zero
        tbView.separatorColor = .tableViewSeparator
        return tbView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        presenter.viewDidLoad()
    }

    func displayTasks(_ tasks: [Task]) {
        self.tasks = tasks
        tableView.reloadData()
    }

    func displayError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func layout() {
        
        let leftRightSpace: CGFloat = 20
        
        [titleLabel, searchView, tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightSpace),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightSpace),
            
            searchView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            searchView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftRightSpace),
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leftRightSpace),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskListTableViewCell.identifier, for: indexPath) as! TaskListTableViewCell
        cell.setupCell(with: tasks[indexPath.row])
        return cell
    }
}

extension TaskListViewController: SearchViewDelegate {
    func didUpdateSearchQuery(_ query: String) {
        presenter.searchTasks(with: query)
    }
    
    func updateUI() {
        view.layoutIfNeeded()
    }
}
