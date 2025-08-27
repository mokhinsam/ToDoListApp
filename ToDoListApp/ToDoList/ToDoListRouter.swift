//
//  ToDoListRouter.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

import Foundation

protocol ToDoListRouterInputProtocol {
    init(view: ToDoListViewController)
    func openToDoDetailsViewController(with todo: Todo)
}

class ToDoListRouter: ToDoListRouterInputProtocol {

    private unowned let view: ToDoListViewController
    
    required init(view: ToDoListViewController) {
        self.view = view
    }
    
    func openToDoDetailsViewController(with todo: Todo) {
        view.performSegue(withIdentifier: "fromToDoListToToDoDetails", sender: todo)
    }
}
