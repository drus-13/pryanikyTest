//
//  NetworkService.swift
//  pryanikyTest
//
//  Created by Andrey on 10.08.2021.
//

import Foundation
import Alamofire

protocol Network {
    func requestData<M: Decodable>(url: URL, _ completion: @escaping(Result<M, AFError>) -> Void)
    func requestImage(url: URL, _ completion: @escaping(Result<Data, AFError>) -> Void)
}

class NetworkService: Network {
    // MARK: - Request Data
    func requestData<M: Decodable>(url: URL, _ completion: @escaping (Result<M, AFError>) -> Void) {
        AF.request(url).validate().responseDecodable(of: M.self) { response in
            switch response.result {
            case .success(let decodableResult):
                completion(.success(decodableResult))
            case .failure(_):
                completion(.failure(response.error!))
            }
        }
    }
    
    // MARK: - Request Image
    func requestImage(url: URL, _ completion: @escaping (Result<Data, AFError>) -> Void) {
        AF.download(url).validate().responseData { responseData in
            switch responseData.result {
            case .success(let data):
                completion(.success(data))
            case .failure(_):
                completion(.failure(responseData.error!))
            }
        }
    }
}
