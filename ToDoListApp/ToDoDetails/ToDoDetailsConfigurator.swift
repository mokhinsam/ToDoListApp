//
//  ToDoDetailsConfigurator.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 27.08.2025.
//

protocol ToDoDetailsConfiguratorInputProtocol {
    func configure(withView view: ToDoDetailsViewController, and todo: CDTodo)
}

class ToDoDetailsConfigurator: ToDoDetailsConfiguratorInputProtocol {
    func configure(withView view: ToDoDetailsViewController, and todo: CDTodo) {
        let presenter = ToDoDetailsPresenter(view: view)
        let interactor = ToDoDetailsInteractor(presenter: presenter, todo: todo)
        view.presenter = presenter
        presenter.interactor = interactor
    }
}

