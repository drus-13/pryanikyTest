//
//  Assembly.swift
//  pryanikyTest
//
//  Created by Andrey on 11.08.2021.
//

import UIKit

protocol AssemblerProtocol {
    func main() -> UIViewController
}

class Assembler: AssemblerProtocol {
    let serviceLayer: ServiceLayer = ServiceLayer.shared
    
    func main() -> UIViewController {
        let view = MainViewController()
        let viewModel = MainViewModel(networkService: serviceLayer.networkService)

        view.viewModel = viewModel
        
        return view
    }
}
