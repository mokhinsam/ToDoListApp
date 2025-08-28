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

protocol ToDoCellDelegate: AnyObject {
    func didTapDoneButton(in cell: ToDoCell)
}

class ToDoCell: UITableViewCell, CellModelRepresentable {
    
    @IBOutlet weak var todoDoneButton: UIButton!
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var todoBodyLabel: UILabel!
    @IBOutlet weak var todoDateLabel: UILabel!
    
    weak var delegate: ToDoCellDelegate?
    
    var viewModel: ToDoCellViewModelProtocol? {
        didSet {
            updateView()
        }
    }
    
    
    @IBAction func todoDoneButtonDidPressed() {
        delegate?.didTapDoneButton(in: self)
    }
    
    private func updateView() {
        guard let viewModel = viewModel as? ToDoCellViewModel else { return }
        todoBodyLabel.text = viewModel.todoBody
        todoDateLabel.text = viewModel.todoDate
        todoDoneButton.tintColor = viewModel.todoCompleted ? .systemYellow : .white
        todoDoneButton.setImage(UIImage(systemName: viewModel.todoDoneButton), for: .normal)
        todoBodyLabel.textColor = viewModel.todoCompleted ? .lightGray : .white
        
        if viewModel.todoCompleted {
            let attributeString = NSMutableAttributedString(string: viewModel.todoTitle)
            attributeString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: attributeString.length)
            )
            attributeString.addAttribute(
                .foregroundColor,
                value: UIColor.lightGray,
                range: NSRange(location: 0, length: attributeString.length)
            )
            todoTitleLabel.attributedText = attributeString
        } else {
            todoTitleLabel.attributedText = NSAttributedString(string: viewModel.todoTitle)
            todoTitleLabel.textColor = .white
        }
    }
}





