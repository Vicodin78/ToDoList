//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by Vicodin on 23.03.2025.
//

import UIKit

class TaskDetailViewController: UIViewController, DetailTaskPresenterOutput {
    
    var presenter: DetailTaskPresenterInput!
    
    private let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        return $0
    }(UIScrollView())
    
    private let taskTitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 3
        return $0
    }(UILabel())
    
    private let taskDateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "SFProText-Regular", size: 12)
        $0.textColor = .whiteF4Alpha05
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private let taskDescriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        return $0
    }(UILabel())
    
    
    func displayTask(_ task: Task) {
        setTextToTaskTitleLabel(task.title)
        taskDateLabel.text = formatDateToString(task.createdAt)
        setTextTotaskDescriptionLabel(task.description)
    }
    
    private func setTextToTaskTitleLabel(_ text: String) {
        taskTitleLabel.attributedText = setAttributedText(
            text: text,
            fontName: "SFProDisplay-Bold",
            textSize: 34,
            letterSpacing: 0.4,
            color: .whiteF4
        )
    }
    
    private func setTextTotaskDescriptionLabel(_ text: String) {
        taskDescriptionLabel.attributedText = setAttributedText(
            text: text,
            fontName: "SFProText-Regular",
            textSize: 16,
            letterSpacing: -0.43,
            color: .whiteF4
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        presenter.viewDidLoad()
    }
    
    private func layout() {
        
        let scrollViewContentInset: CGFloat = 8
        
        [taskTitleLabel, taskDateLabel, taskDescriptionLabel].forEach { scrollView.addSubview($0) }
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            taskTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            taskTitleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            taskTitleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            taskTitleLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -scrollViewContentInset),
            
            taskDateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            taskDateLabel.topAnchor.constraint(equalTo: taskTitleLabel.bottomAnchor, constant: 8),
            taskDateLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            taskDescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            taskDescriptionLabel.topAnchor.constraint(equalTo: taskDateLabel.bottomAnchor, constant: 16),
            taskDescriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            taskDescriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            taskDescriptionLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -scrollViewContentInset)
        ])
    }
}
