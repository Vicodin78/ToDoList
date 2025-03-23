//
//  TaskListTableViewCell.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import UIKit

protocol TaskListTableViewCellDelegate: AnyObject {
    func didTapCompleteMark(for task: Task?)
}

class TaskListTableViewCell: UITableViewCell {
    
    weak var delegate: TaskListTableViewCellDelegate?
    
    private var currentTask: Task?

    private var isCompleted: Bool = false
    
    private lazy var completeMarkButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .center
        $0.addTarget(self, action: #selector(markButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let taskNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private let taskDescriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "SFProText-Regular", size: 12)
        $0.textAlignment = .left
        $0.numberOfLines = 2
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
    
    private func setButtonImage(_ isCompleted: Bool) {
        let image: UIImage = isCompleted ? .checkmarkCircle : .circle
        completeMarkButton.setImage(image.resized(to: CGSize(width: 24, height: 24)), for: .normal)
    }
    
    private func setAttributedTextToNameLable(_ text: String?, _ isCompleted: Bool) {
        guard let text else { return }
        let letterSpacing = -0.43 / taskNameLabel.font.pointSize // Переводим px из макета в pt
        var attributes: [NSAttributedString.Key: Any] = [.kern: letterSpacing]
        
        if isCompleted {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        taskNameLabel.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    private func setColorToTextLables(_ isCompleted: Bool) {
        let color = isCompleted ? UIColor.whiteF4Alpha05 : UIColor.whiteF4
        taskNameLabel.textColor = color
        taskDescriptionLabel.textColor = color
    }
    
    private func updateUI() {
        setButtonImage(isCompleted)
        setColorToTextLables(isCompleted)
        setAttributedTextToNameLable(taskNameLabel.text, isCompleted)
        
    }
    
    func setupCell(with task: Task) {
        currentTask = task
        isCompleted = task.isCompleted
        setAttributedTextToNameLable(task.title, task.isCompleted)
        taskDescriptionLabel.text = task.description
        taskDateLabel.text = UIView.formatDateToString(task.createdAt)
        updateUI()
        layout()
    }
    
    private func toggleCompletion() {
        currentTask?.isCompleted.toggle()
        delegate?.didTapCompleteMark(for: currentTask)
    }
    
    @objc private func markButtonTapped() {
        toggleCompletion()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
//        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        
        let interItemSpacing: CGFloat = 6
        let topAndBottomMargins: CGFloat = 12
        
        [completeMarkButton, taskNameLabel, taskDescriptionLabel, taskDateLabel].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            completeMarkButton.widthAnchor.constraint(equalToConstant: 24),
            completeMarkButton.heightAnchor.constraint(equalToConstant: 48),
            completeMarkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            completeMarkButton.topAnchor.constraint(equalTo: topAnchor),
            
            taskNameLabel.leadingAnchor.constraint(equalTo: completeMarkButton.trailingAnchor, constant: 8),
            taskNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: topAndBottomMargins),
            taskNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            taskDescriptionLabel.leadingAnchor.constraint(equalTo: taskNameLabel.leadingAnchor),
            taskDescriptionLabel.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: interItemSpacing),
            taskDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            taskDateLabel.leadingAnchor.constraint(equalTo: taskNameLabel.leadingAnchor),
            taskDateLabel.topAnchor.constraint(equalTo: taskDescriptionLabel.bottomAnchor, constant: interItemSpacing),
            taskDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            taskDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topAndBottomMargins)
        ])
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
