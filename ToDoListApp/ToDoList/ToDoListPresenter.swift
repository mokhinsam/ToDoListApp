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
    
    func didSelectTodo(at indexPath: IndexPath) {
        guard let todo = dataStore?.todos[indexPath.row] else { return }
        router.openToDoDetailsViewController(with: todo)
    }
    
    func didTapAddButton() {
        router.openToDoDetailsViewController()
    }
    
    func deleteTodo(at indexPath: IndexPath) {
        guard let todo = dataStore?.todos[indexPath.row] else { return }
        interactor.deleteTodo(todo, at: indexPath)
    }
    
    func didUpdateSearchText(_ text: String) {
        if text.isEmpty {
            interactor.fetchTodos()
        } else {
            interactor.fetchTodos(filter: text)
        }
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
        if let updatedTodo = notification.object as? CDTodo {
            if let index = dataStore?.todos.firstIndex(where: { $0.objectID == updatedTodo.objectID }) {
                dataStore?.todos[index] = updatedTodo
                let updatedCellVM = ToDoCellViewModel(todo: updatedTodo)
                view?.reloadRow(at: IndexPath(row: index, section: 0), with: updatedCellVM)
            } else {
                let newCellVM = ToDoCellViewModel(todo: updatedTodo)
                dataStore?.todos.insert(updatedTodo, at: 0)
                view?.insertRow(at: IndexPath(row: 0, section: 0), with: newCellVM)
                view?.updateToDoCountLabel(with: dataStore?.todos.count ?? 0) 
            }
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
        view?.updateToDoCountLabel(with: dataStore.todos.count)
    }
    
    func didDeleteTodo(at indexPath: IndexPath) {
        dataStore?.todos.remove(at: indexPath.row)
        view?.deleteRow(at: indexPath)
        view?.updateToDoCountLabel(with: dataStore?.todos.count ?? 0)
    }
}
