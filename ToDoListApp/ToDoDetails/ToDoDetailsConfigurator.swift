//
//  ToDoDetailsConfigurator.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 27.08.2025.
//

protocol ToDoDetailsConfiguratorInputProtocol {
    func configureForNewToDo(withView view: ToDoDetailsViewController)
    func configureForExistingToDo(withView view: ToDoDetailsViewController, and todo: CDTodo)
}

class ToDoDetailsConfigurator: ToDoDetailsConfiguratorInputProtocol {
    func configureForNewToDo(withView view: ToDoDetailsViewController) {
        let presenter = ToDoDetailsPresenter(view: view, isNewToDo: true)
        let interactor = ToDoDetailsInteractor(presenter: presenter)
        view.presenter = presenter
        presenter.interactor = interactor
    }
    
    func configureForExistingToDo(withView view: ToDoDetailsViewController, and todo: CDTodo) {
        let presenter = ToDoDetailsPresenter(view: view, isNewToDo: false)
        let interactor = ToDoDetailsInteractor(presenter: presenter, todo: todo)
        view.presenter = presenter
        presenter.interactor = interactor
    }
}

