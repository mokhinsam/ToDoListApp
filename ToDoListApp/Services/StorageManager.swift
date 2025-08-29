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
    
    private let viewContext: NSManagedObjectContext
    private let backgroundContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext = persistentContainer.newBackgroundContext()
    }
    
    // MARK: - CRUD
    func saveTodos(_ todos: [Todo]) {
        backgroundContext.perform {
            for todo in todos {
                let cdTodo = CDTodo(context: self.backgroundContext)
                cdTodo.title = todo.todo
                cdTodo.body = ""
                cdTodo.date = "01/01/25"
                cdTodo.createdAt = Date()
                cdTodo.completed = todo.completed
            }
            do {
                try self.backgroundContext.save()
            } catch {
                print("Failed to save todos: \(error)")
            }
        }
    }
    
    func fetchTodos(filter: String, completion: @escaping (Result<[CDTodo], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<CDTodo> = CDTodo.fetchRequest()
        if !filter.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR body CONTAINS[cd] %@", filter, filter)
        }
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        backgroundContext.perform {
            do {
                let filteredTodos = try self.backgroundContext.fetch(fetchRequest)
                let mainContextTodos = self.convertToMainContext(filteredTodos)
                
                DispatchQueue.main.async {
                    completion(.success(mainContextTodos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func createNewToDoWith(title: String, body: String, date: String, completion: @escaping () -> Void) {
        backgroundContext.perform {
            let newToDo = CDTodo(context: self.backgroundContext)
            newToDo.title = title
            newToDo.body = body
            newToDo.date = date
            newToDo.createdAt = Date()
            newToDo.completed = false
            
            do {
                try self.backgroundContext.save()
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Failed to save new todo: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func readTodos(completion: @escaping (Result<[CDTodo], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<CDTodo> = CDTodo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        backgroundContext.perform {
            do {
                let todos = try self.backgroundContext.fetch(fetchRequest)
                let mainContextTodos = self.convertToMainContext(todos)
                
                DispatchQueue.main.async {
                    completion(.success(mainContextTodos))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func update(todo: CDTodo, newTitle: String, newBody: String, completion: @escaping () -> Void) {
        backgroundContext.perform {
            let backgroundTodo = self.backgroundContext.object(with: todo.objectID) as? CDTodo
            guard let todoToUpdate = backgroundTodo else {
                DispatchQueue.main.async { completion() }
                return
            }
            
            var didUpdate = false
            
            if todoToUpdate.body != newBody {
                todoToUpdate.body = newBody
                didUpdate = true
            }
            
            if todoToUpdate.title != newTitle {
                todoToUpdate.title = newTitle.isEmpty
                ? "\(todoToUpdate.body?.prefix(30) ?? "")..."
                : newTitle
                didUpdate = true
            }
            
            if didUpdate {
                do {
                    try self.backgroundContext.save()
                } catch {
                    print("Failed to update todo: \(error)")
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func toggleTodoDone(for todo: CDTodo, completion: @escaping (CDTodo) -> Void) {
        backgroundContext.perform {
            guard let backgroundTodo = self.backgroundContext.object(with: todo.objectID) as? CDTodo else {
                DispatchQueue.main.async {
                    completion(todo)
                }
                return
            }
            
            backgroundTodo.completed.toggle()
            
            do {
                try self.backgroundContext.save()
            } catch {
                print("Failed to toggle todo: \(error)")
            }
            
            guard let mainThreadTodo = self.viewContext.object(with: todo.objectID) as? CDTodo else { return }
    
            DispatchQueue.main.async {
                completion(mainThreadTodo)
            }
        }
    }
    
    func delete(_ todo: CDTodo) {
        backgroundContext.perform {
            let backgroundTodo = self.backgroundContext.object(with: todo.objectID)
            self.backgroundContext.delete(backgroundTodo)
            
            do {
                try self.backgroundContext.save()
            } catch {
                print("Failed to delete todo: \(error)")
            }
        }
    }
    
    // MARK: - Save context helper
    
    func saveContext() {
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

//MARK: - Private Methods
extension StorageManager {
    private func convertToMainContext(_ todos: [CDTodo]) -> [CDTodo] {
        let objectIDs = todos.map { $0.objectID }
        return objectIDs.compactMap { self.viewContext.object(with: $0) as? CDTodo }
    }
}
