//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Vicodin on 23.03.2025.
//

import UIKit

class TaskViewController<P>: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var presenter: P!
    
    private let conteinerViewSpace: CGFloat = 8
    private let taskBodySpace: CGFloat = 16
    
    private let conteinerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var taskNameTextField: UITextField = {
        let font = "SFProDisplay-Bold"
        let textSize: CGFloat = 34
    
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.attributedPlaceholder = self.setAttributedText(
            text: "Название",
            fontName: font,
            textSize: textSize,
            letterSpacing: 0.4,
            color: .whiteF4Alpha05)
        
        $0.textAlignment = .left
        $0.tintColor = .appYellow
        $0.font = UIFont(name: font, size: textSize)
        $0.textColor = .whiteF4
        return $0
    }(UITextField())
    
    private lazy var taskDateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: "SFProText-Regular", size: 12)
        $0.textColor = .whiteF4Alpha05
        $0.text = self.formatDateToString(Date())
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private let taskBodyTextView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.tintColor = .appYellow
        $0.textColor = .whiteF4
        $0.isScrollEnabled = true
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
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
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if self.isMovingFromParent {
//            saveTask()
//        }
//    }
//    
//    private func saveTask() {
//        guard let title = taskNameTextField.text,
//              let description = taskBodyTextView.text,
//              !title.isEmpty,
//              !description.isEmpty
//        else { return }
//        let task = Task.init(id: 0, title: title, description: description, createdAt: Date(), isCompleted: false)
////        presenter.addTask(task)
//    }
    
//    func displayError(_ error: any Error) {
//        
//    }
    
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
            taskBodyTextView.trailingAnchor.constraint(equalTo: conteinerView.trailingAnchor),
            taskBodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if taskBodyTextView.text.isEmpty {
            taskBodyTextView.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }


    //MARK: - UITextViewDelegate
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
