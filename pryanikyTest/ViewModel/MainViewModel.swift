//
//  MainViewModel.swift
//  pryanikyTest
//
//  Created by Andrey on 11.08.2021.
//

import Foundation
import Alamofire

// MARK: - Main View Model Protocol
protocol MainViewModelProtocol {
    func getViewType(index: Int) -> String
    func getViewsCount() -> Int
    func getSelectorData() -> SomeData?
    func fetchData()
    func fetchImage()
    var updateTableView: (() -> Void)? { get set }
    var updateDataInCell: ((_ index: Int, _ data: ResponseData) -> Void)? { get set }
    var updateImageInCell: ((_ index: Int, _ image: UIImage) -> Void)? { get set }
    func cellDidSelected(for row: Int)
    func selectorCellDidSelected(for row: Int)
    var showAlert: ((_ title: String, _ description: String) -> Void)? { get set }
}

class MainViewModel: MainViewModelProtocol {
    // MARK: - Callacks
    var updateTableView: (() -> Void)?
    var updateDataInCell: ((_ index: Int, _ data: ResponseData) -> Void)?
    var updateImageInCell: ((_ index: Int, _ image: UIImage) -> Void)?
    var showAlert: ((_ title: String, _ description: String) -> Void)?
    
    // MARK: - Private Properties
    private var networkService: Network!

    private var data: [ResponseData] = []
    
    private var requestView: [String] = [] {
        didSet {
            updateTableView?()
        }
    }
    
    // MARK: - Initiliser
    init(networkService: Network) {
        self.networkService = networkService
    }
    
    // MARK: - Get Response View
    private func getResponseData(for dataType: String) -> ResponseData? {
        for responseData in data {
            if responseData.name == dataType {
                return responseData
            }
        }
        return nil
    }
    
    // MARK: - Parse Data
    private func parseData() {
        requestView.enumerated().forEach { [weak self] (index, result) in
            guard let self = self else { return }
            
            guard let responseData = getResponseData(for: result) else { return }
            
            self.updateDataInCell?(index, responseData)
        }
    }
    
    // MARK: - Parse Image
    private func parseImage(image: UIImage) {
        requestView.enumerated().forEach { [weak self] (index, result) in
            guard let self = self else { return }
            
            switch result {
            case "picture":
                self.updateImageInCell?(index, image)
            default:
                return
            }
        }
    }
    
    // MARK: - Find Index In Data
    private func findIndexInData(name: String) -> Int? {
        for (index, responseData) in data.enumerated() {
            if responseData.name == name {
                return index
            }
        }
        return nil
    }
    
    // MARK: - Find Index In View
    private func findIndexInView(name: String) -> Int? {
        for (index, responseName) in requestView.enumerated() {
            if responseName == name {
                return index
            }
        }
        return nil
    }
    
    // MARK: - Fetch Data
    func fetchData() {
        guard let dataURL = URL(string: Constants.url) else { return }
        
        networkService.requestData(url: dataURL) { [weak self] (response: Result<NetworkModel, AFError>) in
            guard let self = self else { return }
            switch response {
            case .failure(let error):
                print(error)
            case .success(let model):
                self.requestView = model.view
                self.data = model.data
                
                self.parseData()
            }
        }
    }
    
    // MARK: - Fetch Image
    func fetchImage() {
        guard let imageIndex = findIndexInData(name: "picture"), let imageURLString = data[imageIndex].data.url,
              let imageURL = URL(string: imageURLString) else { return }
        
        networkService.requestImage(url: imageURL) { [weak self] response in
            guard let self = self else { return }
            
            switch response {
            case .failure(let error):
                print(error)
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                
                self.parseImage(image: image)
            }
        }
    }
    
    // MARK: - Get View Type
    func getViewType(index: Int) -> String {
        return requestView[index]
    }
    
    // MARK: - Get Views Count
    func getViewsCount() -> Int {
        return requestView.count
    }
    
    // MARK: - Get Variants Count
    func getSelectorData() -> SomeData? {
        guard let selectorIndex = findIndexInData(name: "selector") else { return nil }
        
        let selectorData = data[selectorIndex].data

        return selectorData
    }
    
    // MARK: - Selected Cell
    func cellDidSelected(for row: Int) {
        guard let responseData = getResponseData(for: requestView[row]) else { return }
        let dataType = requestView[row]
        
        switch dataType {
        case "hz":
            guard let description = responseData.data.text else { return }
            
            showAlert?(dataType, description)
        case "selector":
            guard let description = responseData.data.text else { return }
            
            showAlert?(dataType, description)
        case "picture":
            guard let description = responseData.data.text else { return }
            
            showAlert?(dataType, description)
        default:
            showAlert?("Error", "Description")
        }
    }
    
    // MARK: - Selected Selector Cell
    func selectorCellDidSelected(for row: Int) {
        guard let selectorIndex = findIndexInView(name: "selector") else { return }
        
        guard let responseData = getResponseData(for: requestView[selectorIndex]) else { return }

        guard let description = responseData.data.variants?[row].text else { return }

        showAlert?("selector", description)
    }
}
