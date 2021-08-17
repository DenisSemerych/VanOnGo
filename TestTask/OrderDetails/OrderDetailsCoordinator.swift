//
//  OrderDetailsCoordinator.swift
//  TestTask
//
//  Created by Denys Semerych on 08.08.2021.
//

import UIKit

class OrderDetailsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    
    typealias Request = Order?

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(request order: Order?) {
        let viewModel = OrderDetailsViewModel(state: order != nil ? .viewing(order: order!) : .adding, routing: self)
        let viewController = OrderDetailsViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension OrderDetailsCoordinator: OrderDetailsRouting {
    func orderAdded() {
        navigationController.popViewController(animated: true)
    }
    
    func addPhoto(completion: @escaping ([ImageContainer]) -> Void) {
        let coordinator = ImagePickingCoordinator(navigationController: navigationController)
        coordinator.start(request: completion)
    }
}
