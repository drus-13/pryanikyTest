//
//  SelectorTableView.swift
//  pryanikyTest
//
//  Created by Andrey on 11.08.2021.
//

import UIKit

protocol SelectorTableViewCellDelegate: AnyObject {
    func selectorCellDidSelected(selectedID: Int)
    func getVariantsCount() -> Int
}

class SelectorTableViewCell: UITableViewCell {
    // MARK: - Identifier
    static let identifier: String = "SelectorTableViewCell"
    
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
    
    // MARK: - Set Variants
    func setVariants(_ variants: [Variant]) {
        variants.enumerated().forEach { (index, result) in
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! TextTableViewCell
            
            cell.setCellTitle(result.text)
        }
    }
}

// MARK: - Table View Data Source Extension
extension SelectorTableViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.MainCellSize.selectorCellHeight / 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.getVariantsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier,
                                                 for: indexPath) as! TextTableViewCell
        
        return cell
    }
}

// MARK: - Table View Delegate
extension SelectorTableViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate?.selectorCellDidSelected(selectedID: indexPath.row)
    }
}
