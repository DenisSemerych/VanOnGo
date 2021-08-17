//
//  OrderListViewModel.swift
//  TestTask
//
//  Created by Denys Semerych on 07.08.2021.
//

import Foundation
import Combine

protocol OrderListRouting {
    func routeToAddOrder()
    func routeToView(order: Order)
}

class OrderListViewModel {
    
    private let routing: OrderListRouting
    private let storage: StorageService
    
    let title = "Order List"
    @Published var orders: [Order] = []
    
    init(storage: StorageService = LocalStorageService(), routing: OrderListRouting) {
        self.routing = routing
        self.storage = storage
    }
    
    func addOrder() {
        routing.routeToAddOrder()
    }
    
    func show(index: Int) {
        guard orders.count > index else {
            return
        }
        
        let order = orders[index]
        routing.routeToView(order: order)
    }
    
    func fetchOrders() {
        self.orders = storage.fetchOrders()
    }
}
