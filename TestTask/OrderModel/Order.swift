//
//  Order.swift
//  TestTask
//
//  Created by Denys Semerych on 07.08.2021.
//

import Foundation

class Order {
    let name: String
    let description: String
    let images: [ImageContainer]
    let uuid: UUID
    
    init(name: String, description: String, images: [ImageContainer], uuid: UUID = UUID()) {
        self.name = name
        self.description = description
        self.images = images
        self.uuid = uuid
    }
}

extension String {
    static let orderName = "Order"
}
