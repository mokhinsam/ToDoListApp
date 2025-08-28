//
//  ToDoListPresenter.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//
import Foundation

struct ToDoListDataStore {
    let todos: [CDTodo]
}

class ToDoListPresenter: ToDoListViewOutputProtocol {
    var interactor: ToDoListInteractorInputProtocol!
    var router: ToDoListRouterInputProtocol!
    
    private weak var view: ToDoListViewInputProtocol?
    private var dataStore: ToDoListDataStore?
    
    required init(view: ToDoListViewInputProtocol) {
        self.view = view
        subscribeToUpdates()
    }
    
    func viewDidLoad() {
        interactor.fetchTodos()
    }
    
    func didTapCell(at indexPath: IndexPath) {
        guard let todo = dataStore?.todos[indexPath.row] else { return }
        router.openToDoDetailsViewController(with: todo)
    }
    
    func didTapAddButton() {
        router.openToDoDetailsViewController()
    }
}

//MARK: - Private Methods
extension ToDoListPresenter {
    private func subscribeToUpdates() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleToDoListUpdated),
            name: .todoDidUpdate,
            object: nil
        )
    }

    @objc private func handleToDoListUpdated() {
        interactor.fetchTodos()
    }
}

// MARK: - ToDoListInteractorOutputProtocol
extension ToDoListPresenter: ToDoListInteractorOutputProtocol {
    func todosDidReceive(with dataStore: ToDoListDataStore) {
        self.dataStore = dataStore
        let section = ToDoSectionViewModel()
        dataStore.todos.forEach { section.rows.append(ToDoCellViewModel(todo: $0)) }
        view?.reloadData(for: section)
    }
}
