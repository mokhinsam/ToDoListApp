//
//  ToDoDetailsPresenter.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 27.08.2025.
//

struct ToDoDetailsDataStore {
    let todoTitle: String
    let todoBody: String
    let todoDate: String
}

class ToDoDetailsPresenter: ToDoDetailsViewOutputProtocol {
    
    var interactor: ToDoDetailsInteractorInputProtocol!
    private weak var view: ToDoDetailsViewInputProtocol?
    
    required init(view: ToDoDetailsViewInputProtocol) {
        self.view = view
    }
    
    func showToDoDetails() {
        interactor.showTodoDetails()
    }
}

//MARK: - ToDoDetailsInteractorOutputProtocol
extension ToDoDetailsPresenter: ToDoDetailsInteractorOutputProtocol {
    func receiveToDoDetails(with dataStore: ToDoDetailsDataStore) {
        view?.displayTodoTitle(with: dataStore.todoTitle)
        view?.displayTodoBody(with: dataStore.todoBody)
        view?.displayTodoDate(with: dataStore.todoDate)
    }
}
