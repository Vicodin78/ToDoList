//
//  Extension.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension DateFormatter {
    static func formatDateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter.string(from: date)
    }
}

protocol TextEditingAssistant {
    func setAttributedText(text: String, fontName: String, textSize: CGFloat, letterSpacing: CGFloat, color: UIColor) -> NSAttributedString
}

extension TextEditingAssistant {
    func setAttributedText(text: String, fontName: String, textSize: CGFloat, letterSpacing: CGFloat, color: UIColor) -> NSAttributedString {
        NSAttributedString(
            string: text,
            attributes: [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: UIFont(name: fontName, size: textSize) ?? UIFont.systemFont(ofSize: textSize),
                NSAttributedString.Key.kern: letterSpacing
            ]
        )
    }
}

extension UIViewController: TextEditingAssistant {}
extension UIView: TextEditingAssistant {}

extension Notification.Name {
    static let taskDeleted = Notification.Name("taskDeleted")
}
