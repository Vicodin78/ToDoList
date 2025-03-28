//
//  FooterView.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

import UIKit

protocol FooterViewDelegateProtocol: AnyObject {
    func pushToAddTask()
}

final class FooterView: UIView {
    
    weak var delegate: FooterViewDelegateProtocol?
    
    private lazy var numberOfTasksLabel = createUILable()
    private lazy var prefixLabel = createUILable()
    
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 4
        return $0
    }(UIStackView())
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .center
        button.isUserInteractionEnabled = true
        
        let configuration = UIImage.SymbolConfiguration(font: UIFont(name: "SFProText-Regular", size: 22) ?? .systemFont(ofSize: 22))
        let image = UIImage(systemName: "square.and.pencil", withConfiguration: configuration)?
            .withTintColor(.appYellow, renderingMode: .alwaysTemplate).resized(to: CGSize(width: 28, height: 28))
        
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func addButtonTapped() {
        delegate?.pushToAddTask()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .backgroundGray
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTaskCount(_ taskCount: Int) {
        let letterSpacing = 0.06 / 11 // Переводим px из макета в pt
        let attributes: [NSAttributedString.Key: Any] = [.kern: letterSpacing]
        numberOfTasksLabel.attributedText = NSAttributedString(string: String(taskCount), attributes: attributes)
        prefixLabel.attributedText = NSAttributedString(string: taskWord(for: taskCount), attributes: attributes)
    }
    
    private func createUILable() -> UILabel {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.font = UIFont(name: "SFProText-Regular", size: 11)
        lable.textColor = .whiteF4
        return lable
    }
    
    private func taskWord(for count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100

        if remainder100 >= 11 && remainder100 <= 14 {
            return "Задач"
        }

        switch remainder10 {
        case 1:
            return "Задача"
        case 2, 3, 4:
            return "Задачи"
        default:
            return "Задач"
        }
    }
    
    private func layout() {
        
        [numberOfTasksLabel, prefixLabel].forEach { stackView.addArrangedSubview($0) }
        [stackView, addButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            addButton.heightAnchor.constraint(equalToConstant: 44),
            addButton.widthAnchor.constraint(equalToConstant: 68),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addButton.topAnchor.constraint(equalTo: topAnchor, constant: 5)
        ])
    }
}
