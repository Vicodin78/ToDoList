//
//  TaskViewController.swift
//  ToDoList
//
//  Created by Vicodin on 23.03.2025.
//

import UIKit

class TaskViewController<P>: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    private let notifCenter = NotificationCenter.default
    
    var presenter: P!
    
    private let conteinerViewSpace: CGFloat = 8
    private let taskBodySpace: CGFloat = 16
    
    //MARK: - UI элементы
    private let conteinerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private(set) lazy var taskNameTextField: UITextField = {
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
        $0.text = DateFormatter.formatDateToString(Date())
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private(set) var taskBodyTextView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.tintColor = .appYellow
        $0.textColor = .whiteF4
        $0.isScrollEnabled = true
        $0.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.textContainerInset = .zero
        $0.textContainer.lineFragmentPadding = 0
        return $0
    }(UITextView())
    
    //Атрибуты для текста в теле запроса
    private let taskBodyTextAttribute: [NSAttributedString.Key: Any] = {
        let testSize: CGFloat = 16
        let letterSpacing = -0.43 / testSize // Переводим px из макета в pt
        
        return [
            .font: UIFont(name: "SFProText-Regular", size: testSize) ?? UIFont.systemFont(ofSize: testSize),
            .foregroundColor: UIColor.whiteF4,
            .kern: letterSpacing
        ]
    }()
    
    //MARK: - Методы жизненного цикла View
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        taskNameTextField.delegate = self
        taskBodyTextView.delegate = self
        addCustomBackAction()
        addDoneAction()
        addEdgeSwipeGesture()
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        taskBodyTextView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: conteinerViewSpace + taskBodySpace + conteinerView.frame.size.height
        ).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notifCenter.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notifCenter.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        notifCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notifCenter.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    //MARK: - Вспомогательные методы
    private func setTextToTaskTitleLabel(_ text: String) {
        taskNameTextField.attributedText = setAttributedText(
            text: text,
            fontName: "SFProDisplay-Bold",
            textSize: 34,
            letterSpacing: 0.4,
            color: .whiteF4
        )
    }
    
    private func setTextToTaskDescriptionLabel(_ text: String) {
        taskBodyTextView.attributedText = NSMutableAttributedString(string: text, attributes: taskBodyTextAttribute)
    }
    
    func getDataForTask() -> (title: String?, description: String?) {
        return (title: taskNameTextField.text, description: taskBodyTextView.text)
    }
    
    //MARK: - Методы PresenterOutput
    func displayTask(_ task: Task) {
        setTextToTaskTitleLabel(task.title)
        taskDateLabel.text = DateFormatter.formatDateToString(task.createdAt)
        setTextToTaskDescriptionLabel(task.description)
    }
    
    func displayError(_ error: any Error, _ popAction: @escaping (() -> Void)) {
        
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cencel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            popAction()
        }))
        present(alert, animated: true)
    }
    
    //MARK: - Layout
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
            
            taskBodyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskBodyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            taskBodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - KeyboardShowAndHide
    @objc private func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                self.taskBodyTextView.contentInset.bottom = keyboardSize.height
                self.taskBodyTextView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            }
        }
    }
    
    @objc private func keyboardHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.taskBodyTextView.contentInset.bottom = 0
            self.taskBodyTextView.verticalScrollIndicatorInsets = .zero
        }
    }
    
    //MARK: - CustomDoneAction
    private func addDoneAction() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneButtonAction))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func doneButtonAction() {
        taskNameTextField.endEditing(true)
        taskBodyTextView.endEditing(true)
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    //MARK: - CustomBackActionAndBackSwipe
    private func addCustomBackAction() {
        navigationItem.backAction = UIAction { [weak self] _ in
            self?.saveTask()
        }
    }
    
    private func addEdgeSwipeGesture() {
        let edgeSwipeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgeSwipe))
        edgeSwipeGesture.edges = .left
        view.addGestureRecognizer(edgeSwipeGesture)
    }
    
    @objc private func handleEdgeSwipe(_ gesture: UIScreenEdgePanGestureRecognizer) {
        if gesture.state == .recognized {
            saveTask()
        }
    }

    func saveTask() {
        fatalError("Метод 'saveTask()' в TaskViewController должен быть переопределен в дочернем классе. Это обязательный метод для сохранения задачи, и его нужно реализовать в каждом подклассе.")
    }

    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if taskBodyTextView.text.isEmpty {
            taskBodyTextView.becomeFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }


    //MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let selectedRange = textView.selectedRange // Сохраняем текущую позицию курсора
        textView.typingAttributes = taskBodyTextAttribute
        textView.selectedRange = selectedRange // Восстанавливаем позицию курсора
    }
}
