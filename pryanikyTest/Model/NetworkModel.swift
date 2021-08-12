//
//  PryanikyModel.swift
//  pryanikyTest
//
//  Created by Andrey on 10.08.2021.
//

import Foundation

struct NetworkModel: Codable {
    var data: [ResponseData]
    var view: [String]
}

struct ResponseData: Codable {
    var name: String
    var data: SomeData
}

struct SomeData: Codable {
    var url: String?
    var text: String?
    var selectedId: Int?
    var variants: [Variant]?
}

struct Variant: Codable {
    var id: Int
    var text: String
}
