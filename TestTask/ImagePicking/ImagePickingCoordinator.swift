//
//  ImagePickingCoordinator.swift
//  TestTask
//
//  Created by Денис Семерич on 17.08.2021.
//

import UIKit

class ImagePickingCoordinator: Coordinator {
    typealias Request = ([ImageContainer]) -> Void
    
    private let navigationController: UINavigationController
    private var viewModel: ImagePickingViewModel?

    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(request: @escaping ([ImageContainer]) -> Void) {
        viewModel = ImagePickingViewModel(completion: request)
        
        guard let viewController = viewModel?.pickerViewController() else { return }
        
        navigationController.present(viewController, animated: true, completion: nil)
    }    
}
