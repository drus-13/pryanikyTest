//
//  MainViewController+UITableView.swift
//  pryanikyTest
//
//  Created by Andrey on 11.08.2021.
//

import UIKit

// MARK: - Table View Delegate
extension MainViewController: UITableViewDelegate {
    
    // MARK: - Cell For Row At
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataType = viewModel.getViewType(index: indexPath.row)
        
        switch dataType {
        case "hz":
            return createTextCell(for: indexPath, tableView: tableView)
        case "selector":
            return createSelectorCell(for: indexPath, tableView: tableView)
        case "picture":
            return createImageCell(for: indexPath, tableView: tableView)
        default:
            return createTextCell(for: indexPath, tableView: tableView)
        }
    }
    
    // MARK: - Cell's methods
    private func createTextCell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextTableViewCell.identifier,
                                                       for: indexPath) as? TextTableViewCell else { return UITableViewCell() }

        return cell
    }
    
    private func createSelectorCell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectorTableViewCell.identifier,
                                                       for: indexPath) as? SelectorTableViewCell else { return UITableViewCell() }

        cell.setMainViewController(controller: self)
        return cell
    }
    
    private func createImageCell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier,
                                                       for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
        viewModel.fetchImage()
        return cell
    }
}

// MARK: - Table View Data Source
extension MainViewController: UITableViewDataSource {
    
    // MARK: - Number Of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getViewsCount()
    }
    
    // MARK: - Height For Row At
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataType = viewModel.getViewType(index: indexPath.row)
        
        switch dataType {
        case "hz":
            return Constants.MainCellSize.defaultCellHeight
        case "selector":
            return Constants.MainCellSize.selectorCellHeight
        case "picture":
            return Constants.MainCellSize.imageCellHeight
        default:
            return Constants.MainCellSize.defaultCellHeight
        }
    }
    
    // MARK: - Did Select Row At
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.cellDidSelected(for: indexPath.row)
    }
}
