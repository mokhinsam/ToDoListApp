//
//  ToDoDetailsInteractor.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 27.08.2025.
//

import Foundation

protocol ToDoDetailsInteractorInputProtocol {
    init(presenter: ToDoDetailsInteractorOutputProtocol)
    init(presenter: ToDoDetailsInteractorOutputProtocol, todo: CDTodo)
    func showTodoDetails()
}

protocol ToDoDetailsInteractorOutputProtocol: AnyObject {
    func receiveToDoDetails(with dataStore: ToDoDetailsDataStore)
}


class ToDoDetailsInteractor: ToDoDetailsInteractorInputProtocol {
    
    private weak var presenter: ToDoDetailsInteractorOutputProtocol?
    private var todo: CDTodo?
    
    required init(presenter: ToDoDetailsInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    required init(presenter: ToDoDetailsInteractorOutputProtocol, todo: CDTodo) {
        self.presenter = presenter
        self.todo = todo
    }
    
    func showTodoDetails() {
        guard let todo = todo else { return }
        let dataStore = ToDoDetailsDataStore(
            todoTitle: todo.title ?? "",
            todoBody: todo.body ?? "",
            todoDate: todo.date ?? "00/00/00"
        )
        presenter?.receiveToDoDetails(with: dataStore)
    }
}
