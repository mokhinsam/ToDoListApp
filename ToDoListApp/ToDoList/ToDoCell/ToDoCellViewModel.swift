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
    var todoCompleted: Bool { get }
    init(todo: CDTodo)
}

protocol ToDoSectionViewModelProtocol {
    var rows: [ToDoCellViewModelProtocol] { get set }
    var numberOfRows: Int { get }
}

class ToDoCellViewModel: ToDoCellViewModelProtocol {
    var cellIdentifier: String {
        "ToDoCell"
    }
    
    var todoTitle: String {
        todo.title ?? ""
    }
    
    var todoBody: String {
        todo.body ?? ""
    }
    
    var todoDate: String {
        todo.date ?? ""
    }
    
    var todoDoneButton: String {
        todo.completed ? "checkmark.circle" : "circle"
    }
    
    var todoCompleted: Bool {
        todo.completed
    }
    
    private let todo: CDTodo
    
    required init(todo: CDTodo) {
        self.todo = todo
    }
}

class ToDoSectionViewModel: ToDoSectionViewModelProtocol {
    var rows: [ToDoCellViewModelProtocol] = []
    var numberOfRows: Int {
        rows.count
    }
}
