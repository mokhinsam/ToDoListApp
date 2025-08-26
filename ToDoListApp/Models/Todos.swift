//
//  Todos.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

struct Todos: Decodable {
    let todos: [Todo]
}

struct Todo: Decodable {
    let todo: String
    let note: String?
    let date: String?
    let completed: Bool
}
