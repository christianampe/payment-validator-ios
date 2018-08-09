//
//  FlatDropdownDataSource.swift
//  FlatDropdown
//
//  Created by Ampe on 7/30/18.
//

import Foundation

public protocol FlatDropdownDataSource {
    // MARK: Storage
    var data: [[String]] { get set }
    
    // MARK: Get Methods
    func numberOfRows(for section: Int) -> Int?
    func numberOfSections() -> Int
    func text(for index: IndexPath) -> String?
    
    // MARK: Set Methods
}

public extension FlatDropdownDataSource {
    func numberOfRows(for section: Int) -> Int? {
        guard numberOfSections() >= section + 1 else {
            return nil
        }
        
        return data[section].count
    }
    
    func numberOfSections() -> Int {
        return data.count
    }
    
    func text(for index: IndexPath) -> String? {
        guard numberOfSections() >= index.section + 1 else {
            
            return nil
        }
        
        guard let rowCount = numberOfRows(for: index.section) else {
            
            return nil
        }
        
        guard rowCount >= index.row + 1 else {
            
            return nil
        }
        
        return data[index.section][index.row]
    }
}
