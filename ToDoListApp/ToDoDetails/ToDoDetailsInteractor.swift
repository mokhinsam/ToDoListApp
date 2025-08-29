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
    func updateExistingToDo(title: String, body: String)
    func createNewToDo(title: String, body: String, date: String)
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
        if let todo = todo {
            let dataStore = ToDoDetailsDataStore(
                todoTitle: todo.title ?? "",
                todoBody: todo.body ?? "",
                todoDate: todo.date ?? "00/00/00"
            )
            presenter?.receiveToDoDetails(with: dataStore)
        } else {
            let currentDate = generateCurrentDate()
            let dataStore = ToDoDetailsDataStore(
                todoTitle: "",
                todoBody: "",
                todoDate: currentDate
            )
            presenter?.receiveToDoDetails(with: dataStore)
        }
    }
    
    func updateExistingToDo(title: String, body: String) {
        guard let todo = todo else { return }
        StorageManager.shared.update(todo: todo, newTitle: title, newBody: body) { [weak self] in
            self?.todoDidUpdate(withObject: todo)
        }
    }
    
    func createNewToDo(title: String, body: String, date: String) {
        StorageManager.shared.createNewToDoWith(title: title, body: body, date: date) {[weak self] in
            self?.todoDidUpdate()
        }
    }
}

//MARK: - Private Methods
extension ToDoDetailsInteractor {
    private func generateCurrentDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        return formatter.string(from: date)
    }
    
    private func todoDidUpdate(withObject object: CDTodo? = nil) {
        NotificationCenter.default.post(name: .todoDidUpdate, object: object)
    }
}
