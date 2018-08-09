//
//  FlatDropdownDelegate.swift
//  FlatDropdown
//
//  Created by Ampe on 7/30/18.
//

import FlatField

public protocol FlatDropdownDelegate {
    var flatDropdown: FlatDropdown! { get set }
    
    func didBeginEditing(_ sender: FlatField)
    func textDidChange(_ sender: FlatField)
    func didEndEditing(_ sender: FlatField)
    
    func didSelectRow(_ at: IndexPath, _ sender: FlatDropdown)
}
