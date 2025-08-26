//
//  ToDoListViewController.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

import UIKit

class ToDoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var toDoCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }

    @IBAction func addButtonDidPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "fromToDoListToToDoDetails", sender: self)
    }
    
}

//MARK: - Private Methods
extension ToDoListViewController {
    private func configureUI() {
        navigationController?.navigationBar.tintColor = UIColor.systemYellow
    }
}



