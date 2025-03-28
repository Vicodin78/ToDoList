//
//  PopOverMenuTableViewController.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import UIKit

protocol PopOverMenuDelegate: AnyObject {
    func dismiss()
}

class PopOverMenuTableViewController: UITableViewController, PopOverMenuPresenterOutput {
    
    weak var delegate: PopOverMenuDelegate?
    
    var presenter: PopOverMenuPresenterInput!
    
    private var menuItems: [MenuItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        setupTableView()
        view.backgroundColor = .clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dismiss()
    }
    
    override func viewWillLayoutSubviews() {
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 0.7, height: tableView.contentSize.height)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .systemBlue
        tableView.isScrollEnabled = false
        tableView.register(PopOverMenuTableViewCell.self, forCellReuseIdentifier: PopOverMenuTableViewCell.identifier)
        tableView.separatorColor = .tableViewSeparator.withAlphaComponent(0.5)
        tableView.separatorInset = .zero
    }
    
    func displayMenuItems(_ menuItems: [MenuItem]) {
        self.menuItems = menuItems
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PopOverMenuTableViewCell.identifier, for: indexPath) as! PopOverMenuTableViewCell
        cell.setupCell(menuItems[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapToCell(menuItems[indexPath.row].action)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
