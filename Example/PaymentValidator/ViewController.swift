//
//  ViewController.swift
//  PaymentValidator
//
//  Created by christianampe on 08/09/2018.
//  Copyright (c) 2018 christianampe. All rights reserved.
//

import UIKit
import FlatField
import FlatDropdown
import PaymentValidator

class ViewController: UIViewController {
    var data: [[String]] = [[]]
    
    @IBOutlet weak var flatDropdown: FlatDropdown!
    
    let validator = CreditCardTypeValidator()
}

extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        flatDropdown.delegate = self
        flatDropdown.dataSource = self
    }
}

extension ViewController: FlatDropdownDelegate {
    func textDidChange(_ sender: FlatField) {
        guard let text = sender.textField.text else {
            return
        }
        
        updateData(for: validator.card(for: text))
    }
    
    func didSelectRow(_ at: IndexPath, _ sender: FlatDropdown) {
        // do nothing
    }
    
    func didBeginEditing(_ sender: FlatField) {
        // do nothing
    }
    
    func didEndEditing(_ sender: FlatField) {
        // do nothing
    }
}

extension ViewController: FlatDropdownDataSource {
    func updateData(for state: CreditCardTypeValidationState) {
        data = [[]]
        
        guard let cards = state.cards else {
            flatDropdown.tableView.reloadData()
            return
        }
        
        cards.forEach { card in
            data[0].append(card.name)
        }
        
        flatDropdown.tableView.reloadData()
    }
}
