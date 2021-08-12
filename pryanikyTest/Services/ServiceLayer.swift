//
//  ServiceLayer.swift
//  pryanikyTest
//
//  Created by Andrey on 11.08.2021.
//

import Foundation

final class ServiceLayer {
    // MARK: - Public Properties
    static let shared = ServiceLayer()

    let networkService: Network
    
    // MARK: - Initializers
    private init() {
        self.networkService = NetworkService()
    }
}
