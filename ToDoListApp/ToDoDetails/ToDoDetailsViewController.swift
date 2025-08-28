//
//  ToDoDetailsViewController.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

import UIKit

protocol ToDoDetailsViewInputProtocol: AnyObject {
    func displayTodoTitle(with title: String)
    func displayTodoBody(with body: String)
    func displayTodoDate(with date: String)
    func activateTitleEditing()
}

protocol ToDoDetailsViewOutputProtocol {
    init(view: ToDoDetailsViewInputProtocol, isNewToDo: Bool)
    func showToDoDetails()
    func saveButtonPressed(title: String, body: String, date: String)
}

class ToDoDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var titleTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var bodyTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var presenter: ToDoDetailsViewOutputProtocol!
    
    private var lastTitleTextViewHeight: CGFloat = 0
    private var lastBodyTextViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter.showToDoDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTextViewHeightsIfNeeded()
    }
    
    @IBAction func saveButtonDidPressed(_ sender: UIBarButtonItem) {
        let title = titleTextView.text ?? ""
        let body = bodyTextView.text ?? ""
        let date = dateLabel.text ?? ""
        presenter.saveButtonPressed(title: title, body: body, date: date)
        view.endEditing(true)
        saveButton.isHidden = true
    }
    
    deinit {
        unregisterForKeyboardNotifications()
    }
}

//MARK: - Private Methods
extension ToDoDetailsViewController {
    private func configureUI() {
        titleTextView.delegate = self
        bodyTextView.delegate = self
        titleTextView.isScrollEnabled = false
        bodyTextView.isScrollEnabled = false
        saveButton.isHidden = true
        titleTextView.autocorrectionType = .no
        titleTextView.spellCheckingType = .no
        bodyTextView.autocorrectionType = .no
        bodyTextView.spellCheckingType = .no
        registerForKeyboardNotifications()
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
    
    private func updateTextViewHeightsIfNeeded() {
        let titleWidth = titleTextView.frame.width
        let bodyWidth = bodyTextView.frame.width
        
        guard titleWidth.isFinite && titleWidth > 0,
              bodyWidth.isFinite && bodyWidth > 0 else {
            return
        }
        
        let maxTitleSize = CGSize(width: titleWidth, height: .greatestFiniteMagnitude)
        let fittingTitleHeight = titleTextView.sizeThatFits(maxTitleSize).height
        let newTitleHeight = max(fittingTitleHeight, 50)
        
        let maxBodySize = CGSize(width: bodyWidth, height: .greatestFiniteMagnitude)
        let fittingBodyHeight = bodyTextView.sizeThatFits(maxBodySize).height
        let newBodyHeight = max(fittingBodyHeight, 250)
        
        guard newTitleHeight.isFinite && newTitleHeight > 0,
              newBodyHeight.isFinite && newBodyHeight > 0 else {
            return
        }
        
        if newTitleHeight != lastTitleTextViewHeight
            || newBodyHeight != lastBodyTextViewHeight {
            lastTitleTextViewHeight = newTitleHeight
            lastBodyTextViewHeight = newBodyHeight
            
            titleTextViewHeight.constant = newTitleHeight
            bodyTextViewHeight.constant = newBodyHeight
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
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
        updateTextViewHeightsIfNeeded()
        if titleTextView.text.isEmpty && bodyTextView.text.isEmpty {
            saveButton.isHidden = true
        } else {
            saveButton.isHidden = false
        }
    }
}

//MARK: - ToDoDetailsViewInputProtocol
extension ToDoDetailsViewController: ToDoDetailsViewInputProtocol {
    func displayTodoTitle(with title: String) {
        titleTextView.text = title
        updateTextViewHeightsIfNeeded()
    }
    
    func displayTodoBody(with body: String) {
        bodyTextView.text = body
        updateTextViewHeightsIfNeeded()
    }
    
    func displayTodoDate(with date: String) {
        dateLabel.text = date
    }
    
    func activateTitleEditing() {
        titleTextView.becomeFirstResponder()
    }
}
