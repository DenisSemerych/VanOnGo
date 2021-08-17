//
//  OrderListCoordinatro.swift
//  TestTask
//
//  Created by Denys Semerych on 08.08.2021.
//

import UIKit

class OrderListCoordinator: Coordinator {
    typealias Request = OrderListViewModel?
    
    private let navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(request vm: OrderListViewModel?) {
        let viewController = OrderListViewController(viewModel: vm != nil ? vm! : OrderListViewModel(routing: self))
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
}

extension OrderListCoordinator: OrderListRouting {
    func routeToAddOrder() {
        let coordinator = OrderDetailsCoordinator(navigationController: self.navigationController)
        coordinator.start(request: nil)
    }
    
    func routeToView(order: Order) {
        let coordinator = OrderDetailsCoordinator(navigationController: self.navigationController)
        coordinator.start(request: order)
    }
}
