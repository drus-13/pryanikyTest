//
//  ViewController.swift
//  pryanikyTest
//
//  Created by Andrey on 10.08.2021.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Request Table View
    private lazy var requestTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - View Model
    var viewModel: MainViewModelProtocol! {
        didSet {
            viewModel.updateTableView = { [weak self] in
                guard let self = self else { return }
                
                self.updateTableView()
            }
            
            viewModel.updateDataInCell = { [weak self] (row, data) in
                guard let self = self else { return }

                self.updateCell(for: row, with: data)
            }
            
            viewModel.updateImageInCell = { [weak self] (row, image) in
                guard let self = self else { return }

                self.updateImageCell(for: row, with: image)
            }
            
            viewModel.showAlert = { [weak self] (title, description) in
                guard let self = self else { return }

                self.showAlert(title: title, description: description)
            }
        }
    }
    
    // MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        configureUI()
    }
    
    // MARK: - Configure UI
    private func configureUI() {
        setupRequestTableView()
        setupRequestTableViewConstraints()
    }
    
    // MARK: - Setup Request Table View
    private func setupRequestTableView() {
        requestTableView.dataSource = self
        requestTableView.delegate = self
        requestTableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        requestTableView.register(SelectorTableViewCell.self, forCellReuseIdentifier: SelectorTableViewCell.identifier)
        requestTableView.register(TextTableViewCell.self, forCellReuseIdentifier: TextTableViewCell.identifier)
    }

    // MARK: - Request Table View Constraints
    private func setupRequestTableViewConstraints() {
        view.addSubview(requestTableView)
        requestTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        requestTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        requestTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        requestTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - Update Request Table View
    private func updateTableView() {
        requestTableView.reloadData()
    }
    
    // MARK: - Update Image Cell
    private func updateImageCell(for row: Int, with image: UIImage) {
        let cell = requestTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! ImageTableViewCell
        cell.setCellImage(image)
    }
    
    // MARK: - Update Cells
    private func updateCell(for row: Int, with data: ResponseData) {
        switch data.name {
        case "hz":
            let cell = requestTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! TextTableViewCell
            guard let text = data.data.text else { return }
            
            cell.setCellTitle(text)
        case "selector":
            let cell = requestTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! SelectorTableViewCell
            guard let variants = data.data.variants else { return }
            
            cell.setVariants(variants)
        case "picture":
            let cell = requestTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! ImageTableViewCell
            guard let text = data.data.text else { return }
            
            cell.setImageNameLabel(text)
        default:
            print(data.name)
        }
    }
    
    // MARK: - Show Alert
    private func showAlert(title: String, description: String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
}

// MARK: - Selector Table View Cell Delegate
extension MainViewController: SelectorTableViewCellDelegate {
    
    func getVariantsCount() -> Int {
        return viewModel.getVariantsCount()
    }
    
    func selectorCellDidSelected(selectedID: Int) {
        viewModel.selectorCellDidSelected(for: selectedID)
    }
}
