//
//  ToDoListPresenter.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//
import Foundation

struct ToDoListDataStore {
    var todos: [CDTodo]
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

    @objc private func handleToDoListUpdated(_ notification: Notification) {
        if let updatedTodo = notification.object as? CDTodo,
           let index = dataStore?.todos.firstIndex(where: { $0.objectID == updatedTodo.objectID }) {
            dataStore?.todos[index] = updatedTodo
            let updatedCellVM = ToDoCellViewModel(todo: updatedTodo)
            view?.reloadRow(at: IndexPath(row: index, section: 0), with: updatedCellVM)
        } else {
            interactor.fetchTodos()
        }
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
