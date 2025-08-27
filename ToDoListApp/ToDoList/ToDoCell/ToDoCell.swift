//
//  ToDoCell.swift
//  ToDoListApp
//
//  Created by Дарина Самохина on 26.08.2025.
//

import UIKit

protocol CellModelRepresentable {
    var viewModel: ToDoCellViewModelProtocol? { get }
}

class ToDoCell: UITableViewCell, CellModelRepresentable {
    
    @IBOutlet weak var todoDoneButton: UIButton!
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoBodyLabel: UILabel!
    @IBOutlet weak var todoDateLabel: UILabel!
    
    var viewModel: ToDoCellViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    private func updateView() {
        guard let viewModel = viewModel as? ToDoCellViewModel else { return }
        todoDoneButton.setImage(UIImage(systemName: viewModel.todoDoneButton), for: .normal)
        todoTitleLabel.text = viewModel.todoTitle
        todoBodyLabel.text = viewModel.todoBody
        todoDateLabel.text = viewModel.todoDate
    }
}





