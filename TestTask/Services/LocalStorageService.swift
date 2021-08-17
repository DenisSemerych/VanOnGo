//
//  LocalStorageService.swift
//  TestTask
//
//  Created by Denys Semerych on 08.08.2021.
//

import Foundation

protocol StorageService {
    func save(order: Order)
    func fetchOrders() -> [Order]
}

class LocalStorageService: StorageService {
    private let fileFormat = ".txt"
    
    func save(order: Order) {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let filename = docDirectory.appendingPathComponent(order.uuid.uuidString + fileFormat)
        do {
            try order.description.write(to: filename, atomically: true, encoding: .utf8)
        } catch let error as NSError {
            print(error)
        }
    }
        
    func fetchOrders() -> [Order] {
        guard let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [] }
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(atPath: docDirectory.path)
            
            let orders: [[Date: Order]] = try fileURLs.map { filePath in
                let text = try String(contentsOf: docDirectory.appendingPathComponent(filePath))
                let attributes = try FileManager.default.attributesOfItem(atPath: docDirectory.appendingPathComponent(filePath).path)
                guard let uuid = UUID(uuidString: filePath.replacingOccurrences(of: self.fileFormat, with: "")),
                      let date = attributes[.creationDate] as? Date else {
                    throw NSError()
                }
                return [date: Order(name: .orderName, description: text, images: [], uuid: uuid)]
            }
            
            let sortedOrders = orders.sorted { firstDict, secondDict in
                guard let first = firstDict.first, let second = secondDict.first else { return false }
                return first.key < second.key
            }.compactMap { $0.first?.value }
            
            return sortedOrders
        } catch  let error as NSError  {
            print(error)
            return []
        }
    }
}
