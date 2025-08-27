//
//  ToDoListRouter.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

import Foundation

protocol ToDoListRouterInputProtocol {
    init(view: ToDoListViewController)
    func openToDoDetailsViewController(with todo: CDTodo)
    func openToDoDetailsViewController()
}

class ToDoListRouter: ToDoListRouterInputProtocol {

    private weak var view: ToDoListViewController?
    
    required init(view: ToDoListViewController) {
        self.view = view
    }
    
    func openToDoDetailsViewController(with todo: CDTodo) {
        view?.performSegue(withIdentifier: "fromToDoListToToDoDetails", sender: todo)
    }
    
    func openToDoDetailsViewController() {
        view?.performSegue(withIdentifier: "fromToDoListToToDoDetails", sender: nil)
    }
}
