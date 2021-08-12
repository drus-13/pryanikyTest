//
//  ImageTableViewCell.swift
//  pryanikyTest
//
//  Created by Andrey on 11.08.2021.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    // MARK: - Identifier
    static let identifier: String = "ImageTableViewCell"
    
    // MARK: - Image View
    private lazy var cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Image Label
    private lazy var imageNameLable: UILabel = {
        let label = UILabel()
        label.text = "default"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initilizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImageViewConstraints()
        setupTextLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Image View Constraints
    private func setupImageViewConstraints() {
        addSubview(cellImageView)
        
        cellImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        cellImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cellImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        cellImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    // MARK: - Text Label Constraints
    private func setupTextLabelConstraints() {
        addSubview(imageNameLable)
        
        imageNameLable.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageNameLable.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 10).isActive = true
        imageNameLable.topAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: 10).isActive = true
    }
    
    // MARK: - Public Methods
    func setCellImage(_ image: UIImage) {
        cellImageView.image = image
    }
    
    func setImageNameLabel(_ text: String) {
        imageNameLable.text = text
    }
}
