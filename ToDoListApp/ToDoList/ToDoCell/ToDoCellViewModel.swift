//
//  ToDoCellViewModel.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

import Foundation

protocol ToDoCellViewModelProtocol {
    var cellIdentifier: String { get }
    var todoTitle: String { get }
    var todoBody: String { get }
    var todoDate: String { get }
    var todoDoneButton: String { get }
    init(todo: Todo)
}

protocol ToDoSectionViewModelProtocol {
    var rows: [ToDoCellViewModelProtocol] { get }
    var numberOfRows: Int { get }
}

class ToDoCellViewModel: ToDoCellViewModelProtocol {
    var cellIdentifier: String {
        "ToDoCell"
    }
    
    var todoTitle: String {
        todo.todo
    }
    
    var todoBody: String {
        todo.note ?? todo.todo
    }
    
    var todoDate: String {
        todo.date ?? "01/01/01"
    }
    
    var todoDoneButton: String {
        todo.completed ? "checkmark.circle" : "circle"
    }
    
    private let todo: Todo
    
    required init(todo: Todo) {
        self.todo = todo
    }
}

class ToDoSectionViewModel: ToDoSectionViewModelProtocol {
    var rows: [ToDoCellViewModelProtocol] = []
    var numberOfRows: Int {
        rows.count
    }
}
