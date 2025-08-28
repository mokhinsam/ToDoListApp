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
    private let isNewToDo: Bool
    
    required init(view: ToDoDetailsViewInputProtocol, isNewToDo: Bool) {
        self.view = view
        self.isNewToDo = isNewToDo
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
        
        if isNewToDo {
            view?.activateTitleEditing()
        }
    }
    
    func saveButtonPressed(title: String, body: String, date: String) {
        if isNewToDo {
            interactor.createNewToDo(title: title, body: body, date: date)
        } else {
            interactor.updateExistingToDo(title: title, body: body)
        }
    }

}
