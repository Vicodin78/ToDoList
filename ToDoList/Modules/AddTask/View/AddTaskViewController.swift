//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

import UIKit

final class AddTaskViewController: UIViewController, AddTaskPresenterOutput {
    
    var presenter: AddTaskPresenterInput!
    
    private let conteinerViewSpace: CGFloat = 8
    private let taskBodySpace: CGFloat = 16
    
    private let taskNameTextField: UITextField = {
        let placeholderTextSize: CGFloat = 34
        let letterSpacing = 0.4 / placeholderTextSize // Переводим px из макета в pt
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.attributedPlaceholder = NSAttributedString(
            string: "Название",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.whiteF4Alpha05,
                NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: placeholderTextSize) ?? UIFont.systemFont(ofSize: placeholderTextSize),
                NSAttributedString.Key.kern: letterSpacing
            ]
        )
        $0.textAlignment = .left
        $0.tintColor = .appYellow
        $0.font = UIFont(name: "SFProDisplay-Bold", size: placeholderTextSize)
        $0.textColor = .whiteF4
        return $0
    }(UITextField())
    
    private let taskDateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "SFProText-Regular", size: 12)
        $0.textColor = .whiteF4Alpha05
        $0.text = UIView.formatDateToString(Date())
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private let conteinerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let taskBodyTextView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.tintColor = .appYellow
        $0.textColor = .whiteF4
        $0.isScrollEnabled = true
        $0.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return $0
    }(UITextView())
    

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        taskNameTextField.delegate = self
        taskBodyTextView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        taskBodyTextView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: conteinerViewSpace + taskBodySpace + conteinerView.frame.size.height
        ).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            saveNewTask()
        }
    }
    
    private func saveNewTask() {
        guard let title = taskNameTextField.text,
              let description = taskBodyTextView.text
        else { return }
        let task = Task.init(id: 0, title: title, description: description, createdAt: Date(), isCompleted: false)
        presenter.addTask(task)
    }
    
    func displayError(_ error: any Error) {
        
    }
    
    private func layout() {
        
        [taskNameTextField, taskDateLabel].forEach { conteinerView.addSubview($0) }
        [conteinerView, taskBodyTextView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            taskNameTextField.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor),
            taskNameTextField.topAnchor.constraint(equalTo: conteinerView.topAnchor),
            taskNameTextField.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor),
            
            taskDateLabel.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor),
            taskDateLabel.topAnchor.constraint(equalTo: taskNameTextField.bottomAnchor, constant: conteinerViewSpace),
            taskDateLabel.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor),
            taskDateLabel.bottomAnchor.constraint(equalTo: conteinerView.bottomAnchor),
            
            conteinerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            conteinerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: conteinerViewSpace),
            conteinerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            taskBodyTextView.leadingAnchor.constraint(equalTo: conteinerView.leadingAnchor),
//            taskBodyTextView.topAnchor.constraint(equalTo: conteinerView.bottomAnchor, constant: taskBodySpace),
            taskBodyTextView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor),
            taskBodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func createAttributesForString() -> [NSAttributedString.Key: Any] {
        let testSize: CGFloat = 16
        let letterSpacing = -0.43 / testSize // Переводим px из макета в pt
        
        return [
            .font: UIFont(name: "SFProText-Regular", size: testSize) ?? UIFont.systemFont(ofSize: testSize),
            .foregroundColor: UIColor.whiteF4,
            .kern: letterSpacing
        ]
    }
}

//MARK: - UITextFieldDelegate
extension AddTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
}

//MARK: - UITextViewDelegate
extension AddTaskViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {

    }
    
    func textViewDidChange(_ textView: UITextView) {
        // Сохраняем текущий позицию курсора
        let selectedRange = textView.selectedRange
        
        // Применяем атрибуты ко всему тексту
        textView.attributedText = NSMutableAttributedString(string: textView.text, attributes: createAttributesForString())
        
        // Восстанавливаем позицию курсора
        textView.selectedRange = selectedRange
    }
}
