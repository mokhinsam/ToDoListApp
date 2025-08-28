//
//  ToDoListViewController.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

import UIKit

protocol ToDoListViewInputProtocol: AnyObject {
    func reloadData(for section: ToDoSectionViewModel)
    func reloadRow(at indexPath: IndexPath, with viewModel: ToDoCellViewModel)
    func insertRow(at indexPath: IndexPath, with viewModel: ToDoCellViewModel)
    func deleteRow(at indexPath: IndexPath)
    func updateToDoCountLabel(with count: Int)
}

protocol ToDoListViewOutputProtocol {
    init(view: ToDoListViewInputProtocol)
    func viewDidLoad()
    func didSelectTodo(at indexPath: IndexPath)
    func didTapAddButton()
    func deleteTodo(at indexPath: IndexPath)
    func didDeleteTodo(at indexPath: IndexPath)
    func didUpdateSearchText(_ text: String)
}

class ToDoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toDoCountLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    
    var presenter: ToDoListViewOutputProtocol!
    
    private let configurator: ToDoListConfiguratorInputProtocol = ToDoListConfigurator()
    private var sectionViewModel: ToDoSectionViewModelProtocol = ToDoSectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurator.configure(withView: self)
        presenter.viewDidLoad()
        registerForKeyboardNotifications(scrollView: tableView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromToDoListToToDoDetails" {
            guard let destinationVC = segue.destination as? ToDoDetailsViewController else { return }
            let configurator: ToDoDetailsConfiguratorInputProtocol = ToDoDetailsConfigurator()
            if let todo = sender as? CDTodo {
                configurator.configureForExistingToDo(withView: destinationVC, and: todo)
            } else {
                configurator.configureForNewToDo(withView: destinationVC)
            }
        }
    }

    @IBAction func addButtonDidPressed() {
        presenter.didTapAddButton()
    }
    
    deinit {
        unregisterKeyboardNotifications()
    }
}

//MARK: - Private Methods
extension ToDoListViewController {
    private func configureUI() {
        navigationController?.navigationBar.tintColor = .systemYellow
        searchBar.searchTextField.backgroundColor = .darkGray
    }
}

//MARK: - ScrollView
extension ToDoListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        let isAtBottom = offsetY + frameHeight >= contentHeight - 1
        
        UIView.animate(withDuration: 0.2) {
            self.footerView.backgroundColor = isAtBottom
            ? .black
            : .darkGray
        }
    }
}

//MARK: - UISearchBarDelegate
extension ToDoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didUpdateSearchText(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension ToDoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = sectionViewModel.rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier, for: indexPath)
        guard let cell = cell as? ToDoCell else { return UITableViewCell() }
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ToDoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectTodo(at: indexPath)
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { [weak self] _ in
                self?.presenter.didSelectTodo(at: indexPath)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.presenter.deleteTodo(at: indexPath)
            }
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
        return configuration
    }
}

// MARK: - CourseListViewInputProtocol
extension ToDoListViewController: ToDoListViewInputProtocol {
    func reloadData(for section: ToDoSectionViewModel) {
        sectionViewModel = section
        tableView.reloadData()
    }
    
    func reloadRow(at indexPath: IndexPath, with viewModel: ToDoCellViewModel) {
        sectionViewModel.rows[indexPath.row] = viewModel
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func insertRow(at indexPath: IndexPath, with viewModel: ToDoCellViewModel) {
        sectionViewModel.rows.insert(viewModel, at: indexPath.row)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func deleteRow(at indexPath: IndexPath) {
        sectionViewModel.rows.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func updateToDoCountLabel(with count: Int) {
        toDoCountLabel.text = .todoCountString(for: count)
    }
}
