//
//  FlatDropdownConfig.swift
//  FlatDropdown
//
//  Created by Ampe on 7/30/18.
//

import Foundation

public struct FlatDropdownConfig {
    public let flatFieldHeight: CGFloat
    public let dropdownCellHeight: CGFloat
    public let numberOfResults: Int
    public let numberOfSections: Int
    public let cellReuseIdenfier: String
    
    public init(flatFieldHeight: CGFloat,
                dropdownCellHeight: CGFloat,
                numberOfResults: Int,
                numberOfSections: Int,
                cellReuseIdenfier: String = FlatDropdownConfig.default.cellReuseIdenfier) {
        
        self.flatFieldHeight = flatFieldHeight
        self.dropdownCellHeight = dropdownCellHeight
        self.numberOfResults = numberOfResults
        self.numberOfSections = numberOfSections
        self.cellReuseIdenfier = cellReuseIdenfier
    }
    
    public static let `default` = FlatDropdownConfig(flatFieldHeight: 50,
                                                     dropdownCellHeight: 50,
                                                     numberOfResults: 5,
                                                     numberOfSections: 1,
                                                     cellReuseIdenfier: FlatDropdownCell.reuseIdentifier)
}
