//
//  OrderListView.swift
//  TestTask
//
//  Created by Denys Semerych on 07.08.2021.
//

import UIKit

class OrderListView: UIView {
    
    private let offset: CGFloat = 18
    private let borderHeight: CGFloat = 2
    private let pressed: () -> Void
    
    init(with title: String, pressed: @escaping () -> Void) {
        self.pressed = pressed
        
        super.init(frame: .zero)
        initLayout(title: title)
    }
    
    private func initLayout(title: String) {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.numberOfLines = 0
        addSubview(label)
        
        let border = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.isUserInteractionEnabled = false
        border.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        addSubview(border)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
            label.bottomAnchor.constraint(equalTo: border.topAnchor, constant: -offset),
            
            border.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset),
            border.trailingAnchor.constraint(equalTo: trailingAnchor),
            border.bottomAnchor.constraint(equalTo: bottomAnchor),
            border.heightAnchor.constraint(equalToConstant: borderHeight)
        ])
    }
    
    override init(frame: CGRect) {
        fatalError("use init(with:) instead")
    }
    
    required init?(coder: NSCoder) {
        fatalError("use init(with:) instead")
    }
    
    @objc func tapped() {
        pressed()
    }
}
