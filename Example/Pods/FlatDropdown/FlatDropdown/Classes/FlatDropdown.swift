//
//  FlatDropdown.swift
//  FlatDropdown
//
//  Created by Ampe on 7/30/18.
//

import FlatField

// MARK: - Class Declaration
@IBDesignable
open class FlatDropdown: UIView {
    
    // MARK: Views
    open weak var flatField: FlatField!
    open weak var tableView: UITableView!
    
    // MARK: Storage
    open var delegate: FlatDropdownDelegate?
    open var dataSource: FlatDropdownDataSource?
    
    // MARK: Properties
    open weak var flatFieldHeightConstraint: NSLayoutConstraint!
    
    // MARK: Flat Field IBInspectables
    @IBInspectable
    open var text: String = FlatFieldConfig.default.text {
        didSet {
            flatField.textField.text = text
        }
    }
    
    @IBInspectable
    open var placeholderText: String = FlatFieldConfig.default.placeholderText {
        didSet {
            flatField.textField.placeholder = placeholderText
        }
    }
    
    @IBInspectable
    open var cursorColor: UIColor = FlatFieldConfig.default.cursorColor {
        didSet {
            flatField.textField.tintColor = cursorColor
        }
    }
    
    @IBInspectable
    open var textColor: UIColor = FlatFieldConfig.default.textColor {
        didSet {
            flatField.textField.textColor = textColor
        }
    }
    @IBInspectable
    open var placeholderColor: UIColor = FlatFieldConfig.default.placeholderColor {
        didSet {
            flatField.textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes:[NSAttributedStringKey.foregroundColor: placeholderColor])
        }
    }
    
    @IBInspectable
    open var underlineColor: UIColor = FlatFieldConfig.default.underlineColor {
        didSet {
            flatField.underline.backgroundColor = underlineColor
        }
    }
    
    @IBInspectable
    open var underlineThickness: CGFloat = FlatFieldConfig.default.underlineThickness {
        didSet {
            flatField.underlineHeightConstraint.constant = underlineThickness
        }
    }
    
    @IBInspectable
    open var textAlignment: Int = FlatFieldConfig.default.textAlignment.rawValue {
        didSet {
            guard let alignment = NSTextAlignment(rawValue: textAlignment) else {
                
                assert(false, "use a valid alignment mapping integer (0-4)")
                return
            }
            
            flatField.textField.textAlignment = alignment
        }
    }
    
    @IBInspectable
    open var thicknessChange: CGFloat = FlatFieldConfig.default.thicknessChange
    
    @IBInspectable
    open var flatFieldHeight: CGFloat = FlatDropdownConfig.default.flatFieldHeight {
        didSet {
            flatFieldHeightConstraint.constant = flatFieldHeight
        }
    }
    
    @IBInspectable
    open var dropdownCellHeight: CGFloat = FlatDropdownConfig.default.dropdownCellHeight {
        didSet {
            tableView.rowHeight = dropdownCellHeight
        }
    }
    
    // MARK: Flat Dropdown IBInspectables
    @IBInspectable
    open var maxNumberOfResultsPerSectionToDisplay: Int = FlatDropdownConfig.default.numberOfResults {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBInspectable
    open var maxNumberOfSectionsToDisplay: Int = FlatDropdownConfig.default.numberOfSections {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Designable Initalizers
    public convenience init() {
        
        self.init(frame: CGRect.zero)
    }
    
    public override convenience init(frame: CGRect) {
        
        self.init(frame,
                  config: .default,
                  flatFieldConfig: .default,
                  dataSource: nil,
                  delegate: nil)
    }
    
    // MARK: Programmatic Initalizer
    public init(_ frame: CGRect,
                config: FlatDropdownConfig,
                flatFieldConfig: FlatFieldConfig,
                dataSource: FlatDropdownDataSource?,
                delegate: FlatDropdownDelegate?) {
        
        let flatField = FlatField()
        self.flatField = flatField
        
        let tableView = UITableView()
        self.tableView = tableView
        
        self.dataSource = dataSource
        self.delegate = delegate
        
        super.init(frame: frame)
        
        setupFlatField()
        setupTableView()
        
        addViews()
        addContraints()
        
        initConfig(config,
                   flatFieldConfig: flatFieldConfig)
    }
    
    // MARK: Storyboard Initalizer
    public required init?(coder aDecoder: NSCoder) {
        
        let flatField = FlatField()
        self.flatField = flatField
        
        let tableView = UITableView()
        self.tableView = tableView
        
        super.init(coder: aDecoder)
        
        setupFlatField()
        setupTableView()
        
        addViews()
        addContraints()
        
        initConfig()
    }
}

// MARK: - Setup Methods
private extension FlatDropdown {
    func setupFlatField() {
        
        flatField.delegate = self
    }
    
    func setupTableView() {
        
        tableView.register(FlatDropdownCell.self,
                           forCellReuseIdentifier: FlatDropdownCell.reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.isScrollEnabled = false
        tableView.keyboardDismissMode = .onDrag
    }
    
    func addViews() {
        
        addSubview(flatField)
        addSubview(tableView)
    }
    
    func addContraints() {
        
        flatField.translatesAutoresizingMaskIntoConstraints = false
        
        flatField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        flatField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        flatField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        let flatFieldHeightAnchor = flatField.heightAnchor.constraint(equalToConstant: flatFieldHeight)
        flatFieldHeightAnchor.isActive = true
        
        flatFieldHeightConstraint = flatFieldHeightAnchor
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: flatField.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func initConfig(_ config: FlatDropdownConfig = .default,
                    flatFieldConfig: FlatFieldConfig = .default) {
        
        text = flatFieldConfig.text
        placeholderText = flatFieldConfig.placeholderText
        textColor = flatFieldConfig.textColor
        placeholderColor = flatFieldConfig.placeholderColor
        underlineColor = flatFieldConfig.underlineColor
        underlineThickness = flatFieldConfig.underlineThickness
        thicknessChange = flatFieldConfig.thicknessChange
        textAlignment = flatFieldConfig.textAlignment.rawValue
    }
}

// MARK: - Helper Methods
private extension FlatDropdown {
    func collapseTableView() {
        
        flatField.endEditing(true)
        tableView.isHidden = true
    }
    
    func showTableView() {
        
        tableView.isHidden = false
    }
}

// MARK: - Flat Field Delegate Conformance
extension FlatDropdown: FlatFieldDelegate {
    public func editingBegan(_ sender: FlatField) {
        
        showTableView()
        
        delegate?.didBeginEditing(sender)
    }
    
    public func editingEnded(_ sender: FlatField) {
        
        delegate?.didEndEditing(sender)
    }
    
    public func textChanged(_ sender: FlatField) {
        
        delegate?.textDidChange(sender)
    }
}

// MARK: - Table View Data Source Conformance
extension FlatDropdown: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let dataSource = dataSource else {
            
            return 0
        }
        
        return min(dataSource.numberOfSections(), maxNumberOfSectionsToDisplay)
    }
    
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
        
        guard let dataSource = dataSource else {
            
            return 0
        }
        
        guard let rowCount = dataSource.numberOfRows(for: section) else {
            
            return 0
        }
        
        return min(rowCount, maxNumberOfResultsPerSectionToDisplay)
    }
    
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FlatDropdownCell.reuseIdentifier,
                                                       for: indexPath) as? FlatDropdownCell else {
                                                        
            assert(false, "table view cell registration inconsistency")
            return UITableViewCell()
        }
        
        guard let dataSource = dataSource else {
            
            assert(false, "a data source must be provided")
            return UITableViewCell()
        }
        
        guard let text = dataSource.text(for: indexPath) else {
            
            assert(false, "internal inconsistency - file a bug")
            return UITableViewCell()
        }
        
        cell.update(text)
        
        return cell
    }
}

// MARK: - Table View Delegate Conformance
extension FlatDropdown: UITableViewDelegate {
    public func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
        
        collapseTableView()
        
        flatField.textFieldDidEndEditing(flatField.textField)
        
        delegate?.didSelectRow(indexPath, self)
    }
    
    public func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return dropdownCellHeight
    }
}
