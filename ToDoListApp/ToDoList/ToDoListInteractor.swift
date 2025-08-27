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
}

protocol ToDoListInteractorOutputProtocol: AnyObject {
    func todosDidReceive(with dataStore: ToDoListDataStore)
}

class ToDoListInteractor: ToDoListInteractorInputProtocol {
    private unowned let presenter: ToDoListInteractorOutputProtocol
    
    required init(presenter: ToDoListInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func fetchTodos() {
        NetworkManager.shared.fetchTodos { [unowned self] result in
            switch result {
            case .success(let todos):
                let dataStore = ToDoListDataStore(todos: todos.todos)
                presenter.todosDidReceive(with: dataStore)
            case .failure(let error):
                print("Error NetworkManager in ToDoListInteractor: \(error)")
            }
        }
    }
}
