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
}

protocol ToDoListViewOutputProtocol {
    init(view: ToDoListViewInputProtocol)
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
    func didTapAddButton()
}

class ToDoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toDoCountLabel: UILabel!
    
    var presenter: ToDoListViewOutputProtocol!
    
    private let configurator: ToDoListConfiguratorInputProtocol = ToDoListConfigurator()
    private var sectionViewModel: ToDoSectionViewModelProtocol = ToDoSectionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configurator.configure(withView: self)
        presenter.viewDidLoad()
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
}

//MARK: - Private Methods
extension ToDoListViewController {
    private func configureUI() {
        navigationController?.navigationBar.tintColor = UIColor.systemYellow
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
        presenter.didTapCell(at: indexPath)
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
}
