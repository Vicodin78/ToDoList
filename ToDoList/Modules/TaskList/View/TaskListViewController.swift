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
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskListTableViewCell.self, forCellReuseIdentifier: TaskListTableViewCell.identifier)
        tableView.separatorInset = .zero
        tableView.separatorColor = .tableViewSeparator
        return tableView
    }()
    
    private lazy var footerView: FooterView = {
        $0.delegate = self
        return $0
    }(FooterView())
    
    private let safeAreaView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .backgroundGray
        return $0
    }(UIView())

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        presenter.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .appYellow
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewDidLoad()
        //ERROR
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    func displayTasks(_ tasks: [Task]) {
        self.tasks = tasks
        tableView.reloadData()
        footerView.setTaskCount(tasks.count)
    }

    func displayError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    private func layout() {
        
        let leftRightSpace: CGFloat = 20
        
        [titleLabel, searchView, tableView, footerView, safeAreaView].forEach { view.addSubview($0) }
        
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
//            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
            
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
            safeAreaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaView.topAnchor.constraint(equalTo: footerView.bottomAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        cell.delegate = self
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            let taskId = self.tasks[indexPath.row].id
            self.presenter.deleteTask(taskId: taskId) { success in
                DispatchQueue.main.async {
                    if success {
                        self.tasks.remove(at: indexPath.row)
                        
                        tableView.performBatchUpdates({
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }) { _ in
                            tableView.reloadData()
                        }
                    }
                    completion(success)
                }
            }
        }

        deleteAction.backgroundColor = .appYellow
        deleteAction.image = UIImage(systemName: "trash")?
            .resized(to: CGSize(width: 28, height: 33))?
            .withTintColor(.backgroundGray)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension TaskListViewController: SearchViewDelegate {
    func didUpdateSearchQuery(_ query: String) {
        presenter.searchTasks(with: query)
    }
    
    func updateUI() {
        view.layoutIfNeeded()
    }
    
    func showAlert(viewControllerToPresent: UIViewController, animated: Bool) {
        present(viewControllerToPresent, animated: animated)
    }
}

extension TaskListViewController: TaskListTableViewCellDelegate {
    func didTapCompleteMark(for task: Task?) {
        guard let task = task else { return }
        presenter?.updateTask(task)
    }
}

extension TaskListViewController: FooterViewDelegateProtocol {
    func pushToAddTask() {
        presenter.didTapAddTaskScreen()
    }
}

extension TaskListViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return SlideTransitionAnimator(isPresenting: true)  // Кастомная анимация для push
        } else {
            return nil  // Стандартная анимация для pop
        }
    }
}
