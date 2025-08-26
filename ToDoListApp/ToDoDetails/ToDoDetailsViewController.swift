//
//  ToDoDetailsViewController.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

import UIKit

class ToDoDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var titleTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var bodyTextViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        bodyTextView.delegate = self
        titleTextView.isScrollEnabled = false
        bodyTextView.isScrollEnabled = false
        
        configureUI()
        registerForKeyboardNotifications()
    }
    


    deinit {
        unregisterForKeyboardNotifications()
    }
}

//MARK: - Private Methods
extension ToDoDetailsViewController {
    private func configureUI() {
        titleTextView.becomeFirstResponder()
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    private func unregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        guard let keyboardFrame = keyboardFrame as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
}

//MARK: - UITextViewDelegate
extension ToDoDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeights()
    }

    func updateTextViewHeights() {
        let maxWidth = titleTextView.frame.width
        let titleSize = titleTextView.sizeThatFits(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        )
        titleTextViewHeight.constant = max(titleSize.height, 50)
        
        let bodySize = bodyTextView.sizeThatFits(
            CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        )
        bodyTextViewHeight.constant = max(bodySize.height, 250)

        view.layoutIfNeeded()
    }
}
