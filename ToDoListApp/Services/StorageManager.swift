//
//  StorageManager.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 27.08.2025.
//
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoListApp")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    func saveTodos(_ todos: [Todo]) {
        for todo in todos {
            let cdTodo = CDTodo(context: viewContext)
            cdTodo.title = todo.todo
            cdTodo.body = ""
            cdTodo.date = "01/01/25"
            cdTodo.completed = todo.completed
        }
        saveContext()
    }
    
    //MARK: - CRUD
    func createNewToDoWith(title: String, body: String, date: String) {
        let newToDo = CDTodo(context: viewContext)
        newToDo.title = title
        newToDo.body = body
        newToDo.date = date
        saveContext()
    }
    
    func readTodos(completion: (Result<[CDTodo], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<CDTodo> = CDTodo.fetchRequest()
        
        do {
            let todos = try viewContext.fetch(fetchRequest)
            completion(.success(todos))
        } catch {
            print("Failed to fetch from CoreData: \(error)")
            completion(.failure(error))
        }
    }
    
    func update(todo: CDTodo, newTitle: String, newBody: String) {
        var didUpdate = false
        
        if todo.body != newBody {
            todo.body = newBody
            didUpdate = true
        }

        if todo.title != newTitle {
            todo.title = newTitle.isEmpty
            ? "\(todo.body?.prefix(30) ?? "")..."
            : newTitle
            didUpdate = true
        }

        if didUpdate {
            saveContext()
        }
    }
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
