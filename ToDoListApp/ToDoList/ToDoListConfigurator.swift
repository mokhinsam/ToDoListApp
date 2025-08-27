//
//  ToDoListConfigurator.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

protocol ToDoListConfiguratorInputProtocol {
    func configure(withView view: ToDoListViewController)
}

class ToDoListConfigurator: ToDoListConfiguratorInputProtocol {
    func configure(withView view: ToDoListViewController) {
        let presenter = ToDoListPresenter(view: view)
        let interactor = ToDoListInteractor(presenter: presenter)
        let router = ToDoListRouter(view: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
