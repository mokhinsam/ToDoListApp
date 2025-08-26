//
//  NetworkManager.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    static let shared = NetworkManager()
    
    private let api = "https://dummyjson.com/todos"
    
    private init() {}
    
    func fetchTodos(completion: @escaping (Result<Todos, NetworkError>) -> Void) {
        guard let url = URL(string: api) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let todos = try JSONDecoder().decode(Todos.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(todos))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
