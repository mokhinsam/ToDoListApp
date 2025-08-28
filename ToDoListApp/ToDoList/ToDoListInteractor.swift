//
//  ToDoListInteractor.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//
import Foundation

protocol ToDoListInteractorInputProtocol {
    init(presenter: ToDoListInteractorOutputProtocol)
    func fetchTodos()
    func fetchTodos(filter: String)
    func deleteTodo(_ todo: CDTodo, at indexPath: IndexPath)
}

protocol ToDoListInteractorOutputProtocol: AnyObject {
    func todosDidReceive(with dataStore: ToDoListDataStore)
    func didDeleteTodo(at indexPath: IndexPath)
}

class ToDoListInteractor: ToDoListInteractorInputProtocol {
    
    private weak var presenter: ToDoListInteractorOutputProtocol?
    
    required init(presenter: ToDoListInteractorOutputProtocol) {
        self.presenter = presenter
    }

    func fetchTodos() {
        if !UserDefaults.standard.bool(forKey: "hasLoadedTodos") {
            NetworkManager.shared.fetchTodos { [weak self] result in
                switch result {
                case .success(let todos):
                    StorageManager.shared.saveTodos(todos.todos)
                    UserDefaults.standard.set(true, forKey: "hasLoadedTodos")
                    self?.fetchTodosInDataBase()
                case .failure(let error):
                    print("Error NetworkManager in ToDoListInteractor: \(error)")
                }
            }
        } else {
            fetchTodosInDataBase()
        }
    }
    
    func fetchTodos(filter: String) {
        StorageManager.shared.fetchTodos(filter: filter) { result in
            switch result {
            case .success(let todos):
                presenter?.todosDidReceive(with: ToDoListDataStore(todos: todos))
            case .failure(_ ):
                presenter?.todosDidReceive(with: ToDoListDataStore(todos: []))
            }
        }
    }
    
    func deleteTodo(_ todo: CDTodo, at indexPath: IndexPath) {
        StorageManager.shared.delete(todo)
        presenter?.didDeleteTodo(at: indexPath)
    }
}

//MARK: - Private Methods
extension ToDoListInteractor {
    private func fetchTodosInDataBase() {
        StorageManager.shared.readTodos { [weak self] result in
            switch result {
            case .success(let localTodos):
                let dataStore = ToDoListDataStore(todos: localTodos)
                self?.presenter?.todosDidReceive(with: dataStore)
            case .failure(let error):
                print("Error StorageManager readTodos in ToDoListInteractor: \(error)")
            }
        }
    }
}
