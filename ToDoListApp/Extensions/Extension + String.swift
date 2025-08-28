//
//  Extension + String.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 28.08.2025.
//

extension String {
    static func todoCountString(for count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100

        let form: String
        if remainder100 >= 11 && remainder100 <= 14 {
            form = "Задач"
        } else if remainder10 == 1 {
            form = "Задача"
        } else if remainder10 >= 2 && remainder10 <= 4 {
            form = "Задачи"
        } else {
            form = "Задач"
        }

        return "\(count) \(form)"
    }
}
