//
//  CarouselImageView.swift
//  TestTask
//
//  Created by Denys Semerych on 08.08.2021.
//

import UIKit

class CarouselImageView: UIView {
    
    private let deleteCompletion: () -> Void
    private let offset: CGFloat = 10
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(.remove, for: .normal)
        
        button.addTarget(self, action: #selector(self.deleteItem), for: .touchUpInside)
        
        return button
    }()
    private let imageView = UIImageView()
    
    init(image: UIImage, delete: @escaping () -> Void) {
        deleteCompletion = delete
        super.init(frame: .zero)
        initLayout()
        imageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("use init(data:) intead")
    }
    
    override init(frame: CGRect) {
        fatalError("use init(data:) intead")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    private func initLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset),
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func deleteItem() {
        deleteCompletion()
    }
}
