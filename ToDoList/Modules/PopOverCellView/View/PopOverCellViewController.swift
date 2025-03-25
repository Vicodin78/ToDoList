//
//  PopOverTVCell.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import UIKit

class PopOverCellViewController: UIViewController, PopOverCellPresenterOutput {
    
    var presenter: PopOverCellPresenterInput!
    
    private var cellPosition: CGPoint = .zero
    private var task: Task?
    
    private let backGroundFrame: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .backgroundGray
        $0.layer.cornerRadius = 12
        return $0
    }(UIView())
    
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 6
        return $0
    }(UIStackView())
    
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
    
    private func setValueCell() {
        guard let task else { return }
        setColorToTextLables(task.isCompleted)
        setAttributedTextToNameLable(task.title, task.isCompleted)
        taskDescriptionLabel.text = task.description
        taskDateLabel.text = DateFormatter.formatDateToString(task.createdAt)
        layout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
        addBlurView()
        setValueCell()
    }
    
    func displayCell(task: Task, cellPosition: CGPoint) {
        self.task = task
        self.cellPosition = cellPosition
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPopOver()
    }
    
    private func addBlurView() {
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.backgroundColor = .appBlack.withAlphaComponent(0.5)
        blurView.alpha = 0.7
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurView)
    }
    
    private func layout() {
        
        let leftRightSpacing: CGFloat = 16
        let topBottomSpacing: CGFloat = 12
        
        [taskNameLabel, taskDescriptionLabel, taskDateLabel].forEach { stackView.addArrangedSubview($0) }
        view.addSubview(backGroundFrame)
        backGroundFrame.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            backGroundFrame.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backGroundFrame.topAnchor.constraint(equalTo: view.topAnchor, constant: cellPosition.y),
            backGroundFrame.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            stackView.leadingAnchor.constraint(equalTo: backGroundFrame.leadingAnchor, constant: leftRightSpacing),
            stackView.topAnchor.constraint(equalTo: backGroundFrame.topAnchor, constant: topBottomSpacing),
            stackView.trailingAnchor.constraint(equalTo: backGroundFrame.trailingAnchor, constant: -leftRightSpacing),
            stackView.bottomAnchor.constraint(equalTo: backGroundFrame.bottomAnchor, constant: -topBottomSpacing)
        ])
    }
    
    private func addPopOver() {
        guard let task else { return }
        let popoverContent = PopOverMenuBuilder.build(task)
        popoverContent.delegate = presenter
        popoverContent.modalPresentationStyle = .popover

        if let popoverController = popoverContent.popoverPresentationController {
            let downPosition = UIScreen.main.bounds.height/2 > cellPosition.y
            
            let down = CGRect(
                x: backGroundFrame.bounds.midX,
                y: backGroundFrame.bounds.maxY,
                width: 0,
                height: backGroundFrame.bounds.height + 60)
            let up = CGRect(
                x: backGroundFrame.bounds.midX,
                y: backGroundFrame.bounds.minY,
                width: 0,
                height: -backGroundFrame.bounds.height - 32)
            
            popoverController.permittedArrowDirections = []
            
            popoverController.delegate = self
            popoverController.sourceView = backGroundFrame
            popoverController.sourceRect = downPosition ? down : up
        }

        present(popoverContent, animated: true)
    }
}

extension PopOverCellViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
