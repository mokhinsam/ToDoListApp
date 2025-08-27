//
//  ToDoListViewController.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

import UIKit

protocol ToDoListViewInputProtocol: AnyObject {
    func reloadData(for section: ToDoSectionViewModel)
}

protocol ToDoListViewOutputProtocol {
    init(view: ToDoListViewInputProtocol)
    func viewDidLoad()
    func didTapCell(at indexPath: IndexPath)
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

    @IBAction func addButtonDidPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "fromToDoListToToDoDetails", sender: self)
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
}


