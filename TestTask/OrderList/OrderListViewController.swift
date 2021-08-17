//
//  ViewController.swift
//  TestTask
//
//  Created by Denys Semerych on 07.08.2021.
//

import UIKit
import Combine

class OrderListViewController: UIViewController {
    
    // MARK: Bindings
    private var bindings = Set<AnyCancellable>()
    
    // MARK: Properties
    private let viewModel: OrderListViewModel
    
    private let stackSpacing: CGFloat = 2
    
    // MARK: Outlets
    private lazy var stackView = UIStackView()
    
    init(viewModel: OrderListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        self.title = viewModel.title
        view.backgroundColor = .white
        
        initLayout()

        viewModel.$orders
            .sink(receiveValue: { [weak self] orders in
                guard let self = self else { return }
                self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                for (index, order) in orders.enumerated() {
                    self.stackView.addArrangedSubview(OrderListView(with: "\(order.name) \(index)", pressed: { self.viewModel.show(index: index) }))
                }
        }).store(in: &bindings)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("use init(viewModel:) instead")
    }
    
    required init?(coder: NSCoder) {
        fatalError("use init(viewModel:) instead")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let barButtonItem = UIBarButtonItem(systemItem: .add)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = barButtonItem
        barButtonItem.action = #selector(addButtonPressed)
        barButtonItem.target = self
    }
    
    private func initLayout() {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = stackSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(stackView)

        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scroll.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            stackView.topAnchor.constraint(equalTo: scroll.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scroll.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    @objc private func addButtonPressed() {
        viewModel.addOrder()
    }
}

