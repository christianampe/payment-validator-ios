//
//  FlatFieldDelegate.swift
//  FlatField
//
//  Created by Ampe on 7/28/18.
//

import UIKit

public protocol FlatFieldDelegate {
    var flatField: FlatField! { get set }
    
    func editingBegan(_ sender: FlatField)
    func textChanged(_ sender: FlatField)
    func editingEnded(_ sender: FlatField)
}
