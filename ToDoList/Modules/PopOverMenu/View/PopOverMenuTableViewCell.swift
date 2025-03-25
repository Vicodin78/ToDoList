//
//  PopOverMenuTableViewCell.swift
//  ToDoList
//
//  Created by Vicodin on 24.03.2025.
//

import UIKit

class PopOverMenuTableViewCell: UITableViewCell {

    private let title: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private let icon: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let customSelectView = UIView()
        customSelectView.backgroundColor = .backgroundGray.withAlphaComponent(0.35)
        selectedBackgroundView = customSelectView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ item: MenuItem) {
        self.title.attributedText = setAttributedText(
            text: item.title,
            fontName: "SFProText-Regular",
            textSize: 17,
            letterSpacing: -0.41,
            color: item.action == .delete ? .appRed : .appBlack)
        
        self.icon.image = UIImage(named: item.icon)
        layout()
        backgroundColor = .popOverGray
    }
    
    private func layout() {
        
        let horizontalSpace: CGFloat = 16
        let verticalSpace: CGFloat = 11
        
        [title, icon].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalSpace),
            title.topAnchor.constraint(equalTo: topAnchor, constant: verticalSpace),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalSpace),
            
            icon.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 8),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalSpace),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.widthAnchor.constraint(equalToConstant: 16),
            icon.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    
    
    

}
