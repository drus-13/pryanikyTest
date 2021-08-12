//
//  TextTableViewCell.swift
//  pryanikyTest
//
//  Created by Andrey on 11.08.2021.
//

import UIKit

final class TextTableViewCell: UITableViewCell {
    // MARK: - Identifier
    static let identifier = "TextTableViewCell"
    
    // MARK: - Title Label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "default"
        label.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTextLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Text Label Constraints
    private func setupTextLabelConstraints() {
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    // MARK: - Public methods
    func setCellTitle(_ title: String) {
        titleLabel.text = title
    }
}
