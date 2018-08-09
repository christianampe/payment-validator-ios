//
//  FlatDropdownCell.swift
//  FlatDropdown
//
//  Created by Ampe on 7/30/18.
//

import Foundation

open class FlatDropdownCell: UITableViewCell {
    open weak var label: UILabel!
    
    open func update(_ string: String) {
        label.text = string
    }
    
    // MARK: Initalizers
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        let label = UILabel()
        self.label = label
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
        addViews()
        addConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        let label = UILabel()
        self.label = label
        
        super.init(coder: aDecoder)
        
        initViews()
        addViews()
        addConstraints()
    }
}

public extension FlatDropdownCell {
    static let reuseIdentifier = "FlatDropdownCell"
}

private extension FlatDropdownCell {
    func initViews() {
        selectionStyle = .none
    }
    
    func addViews() {
        addSubview(label)
    }
    
    func addConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
}
