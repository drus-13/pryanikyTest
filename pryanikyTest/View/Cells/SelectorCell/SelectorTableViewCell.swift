//
//  SelectorTableView.swift
//  pryanikyTest
//
//  Created by Andrey on 11.08.2021.
//

import UIKit

protocol SelectorTableViewCellDelegate: AnyObject {
    func selectorCellDidSelected(selectedID: Int)
    func getSelectorData() -> SomeData?
}

class SelectorTableViewCell: UITableViewCell {
    // MARK: - Identifier
    static let identifier: String = "SelectorTableViewCell"
    
    // MARK: - Private Properties
    private var checkedCellIndexPath: IndexPath?
    private var selectorData: SomeData? {
        didSet {
            guard let index = selectorData?.selectedId else { return }

            checkedCellIndexPath = IndexPath(row: index, section: 0)
        }
    }
    
    private let checkedColour: UIColor = .green
    private let uncheckedColour: UIColor = .white
    
    // MARK: - TableView
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TextTableViewCell.self,
                           forCellReuseIdentifier: TextTableViewCell.identifier)
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - View Controller Delegate
    private weak var delegate: SelectorTableViewCellDelegate?
    
    // MARK: - Initilizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTableViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Inject Delegate View Controller
    func setMainViewController(controller: SelectorTableViewCellDelegate) {
        delegate = controller
    }
    
    // MARK: - Table View Constraints
    private func setupTableViewConstraints() {
        contentView.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    // MARK: - Get Selector Data
    private func getSelectorData() {
        selectorData = delegate?.getSelectorData()
    }
    
    // MARK: - Check Index
    private func checkIndex(_ index: Int, for cell: TextTableViewCell) {
        if index == checkedCellIndexPath?.row {
            cell.setCellBackgroundColour(colour: checkedColour)
            checkedCellIndexPath = IndexPath(row: index, section: 0)
        } else {
            cell.setCellBackgroundColour(colour: uncheckedColour)
        }
    }
    
    // MARK: - Set Variants
    func setSelectorData(_ selectorData: SomeData) {
        self.selectorData = selectorData
        
        selectorData.variants?.enumerated().forEach { (index, result) in
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! TextTableViewCell
            
            checkIndex(index, for: cell)
            
            cell.setCellTitle(result.text)
        }
    }
}

// MARK: - Table View Data Source Extension
extension SelectorTableViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let variantsCount = delegate?.getSelectorData()?.variants?.count else {
            return Constants.MainCellSize.selectorCellHeight
        }
        
        return Constants.MainCellSize.selectorCellHeight / CGFloat(variantsCount)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.getSelectorData()?.variants?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier,
                                                 for: indexPath) as! TextTableViewCell
        
        checkIndex(indexPath.row, for: cell)
        
        return cell
    }
}

// MARK: - Table View Delegate
extension SelectorTableViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let previousIndexPath = checkedCellIndexPath else { return }
        
        let previousCell = tableView.cellForRow(at: previousIndexPath) as! TextTableViewCell
        
        previousCell.setCellBackgroundColour(colour: uncheckedColour)
        
        let cell = tableView.cellForRow(at: indexPath) as! TextTableViewCell
        
        cell.setCellBackgroundColour(colour: checkedColour)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        delegate?.selectorCellDidSelected(selectedID: indexPath.row)
        checkedCellIndexPath = indexPath
    }
}
