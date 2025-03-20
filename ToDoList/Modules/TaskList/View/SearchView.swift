//
//  SearchView.swift
//  ToDoList
//
//  Created by Vicodin on 20.03.2025.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func didUpdateSearchQuery(_ query: String)
    func updateUI()
}

class SearchView: UIView {
    
    weak var delegate: SearchViewDelegate?
    
    //Переменные с Constraint для кнопки отмены
    private var buttonIsHiden = [NSLayoutConstraint]()
    private var buttonNotHiden = [NSLayoutConstraint]()
    
    //Отслеживание состояния кнопки отмены в поле поиска
    private var isHiddenCancelButton = true
    
    private let backgroundView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .backgroundGray
        $0.layer.cornerRadius = 10
        return $0
    }(UIView())
    
    private let imgSearchView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false

        let font = UIFont(name: "SFProText-Regular", size: 17)
        let config = UIImage.SymbolConfiguration(font: font ?? .systemFont(ofSize: 17))
        let image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        
        $0.image = image
        $0.tintColor = .whiteF4Alpha05
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private lazy var textField: UITextField = {
        let placeholderTextSize: CGFloat = 17
        let letterSpacing = -0.43 / placeholderTextSize // Переводим px из макета в pt
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.whiteF4Alpha05,
                NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: placeholderTextSize) ?? UIFont.systemFont(ofSize: placeholderTextSize),
                NSAttributedString.Key.kern: letterSpacing
            ]
        )
        $0.textAlignment = .left
        $0.tintColor = .appYellow
        $0.font = UIFont(name: "SFProText-Regular", size: placeholderTextSize)
        $0.textColor = .whiteF4
        $0.addTarget(self, action: #selector(endEditionTextField), for: .editingChanged)
        $0.delegate = self
        return $0
    }(UITextField())
    
    private lazy var voiceButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        $0.tintColor = .whiteF4Alpha05
        return $0
    }(UIButton())
    
    private lazy var cancelButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setAttributedTitle(NSAttributedString(
            string: "Cancel",
            attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.appYellow,
                NSAttributedString.Key.font: UIFont(name: "SFProText-Regular", size: 17) ??
                UIFont.systemFont(ofSize: 17, weight: .regular)
            ]
        ), for: .normal)
        $0.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        $0.isHidden = true
        return $0
    }(UIButton())
    
    
    @objc private func endEditionTextField() {
        delegate?.didUpdateSearchQuery(textField.text ?? "")
    }
    
    private func changeCancelState() {
        isHiddenCancelButton.toggle()
        self.setButtonWeigth()
        UIView.animate(withDuration: 0.3) {
            self.cancelButton.alpha = self.isHiddenCancelButton ? 0 : 1
            self.delegate?.updateUI()
        } completion: { _ in
            self.cancelButton.isHidden = self.isHiddenCancelButton
        }
    }
    
    @objc private func cancelButtonAction() {
        textField.text = ""
        changeCancelState()
        endEditionTextField()
        textField.endEditing(true)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setButtonWeigth() {
        if isHiddenCancelButton {
            NSLayoutConstraint.deactivate(buttonNotHiden)
            NSLayoutConstraint.activate(buttonIsHiden)
        } else {
            NSLayoutConstraint.deactivate(buttonIsHiden)
            NSLayoutConstraint.activate(buttonNotHiden)
        }
    }
    
    private func layout() {
        
        [imgSearchView, textField, voiceButton].forEach {backgroundView.addSubview($0)}
        [backgroundView, cancelButton].forEach {addSubview($0)}
        
        buttonIsHiden = [cancelButton.widthAnchor.constraint(equalToConstant: 0)]
        buttonNotHiden = [cancelButton.widthAnchor.constraint(equalToConstant: 74)]
        
        setButtonWeigth()
        
        NSLayoutConstraint.activate([
            imgSearchView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 6),
            imgSearchView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 7),
            imgSearchView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -7),
            imgSearchView.heightAnchor.constraint(equalToConstant: 22),
            imgSearchView.widthAnchor.constraint(equalToConstant: 20),
            
            voiceButton.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            voiceButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            voiceButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            voiceButton.heightAnchor.constraint(equalToConstant: 36),
            voiceButton.widthAnchor.constraint(equalToConstant: 33),
            
            textField.leadingAnchor.constraint(equalTo: imgSearchView.trailingAnchor, constant: 3),
            textField.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: voiceButton.leadingAnchor),
            
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
}

//MARK: - UITextFieldDelegate

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isHiddenCancelButton {
            changeCancelState()
        }
    }
}
