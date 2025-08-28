//
//  Extension + UIViewController.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 28.08.2025.
//

import UIKit

extension UIViewController {
    func registerForKeyboardNotifications(scrollView: UIScrollView) {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            guard let userInfo = notification.userInfo else { return }
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            guard let keyboardFrame = keyboardFrame as? CGRect else { return }
            let keyboardHeight = keyboardFrame.height
            scrollView.contentInset.bottom = keyboardHeight
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            scrollView.contentInset.bottom = 0
            scrollView.verticalScrollIndicatorInsets.bottom = 0
        }
    }

    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}
