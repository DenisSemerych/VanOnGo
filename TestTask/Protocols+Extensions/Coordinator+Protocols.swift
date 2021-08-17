//
//  Coordinator+Protocols.swift
//  TestTask
//
//  Created by Denys Semerych on 08.08.2021.
//

import UIKit

protocol Coordinator {
    associatedtype Request
    
    init(navigationController: UINavigationController)
    func start(request: Request)
}
