//
//  ImageCarousel.swift
//  TestTask
//
//  Created by Denys Semerych on 08.08.2021.
//

import UIKit
import Combine

class ImageCarousel: UIScrollView {
    
    // MARK: Properties
    @Published var deletionIndex: Int?
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = itemSpacing
        
        return stackView
    }()
    private var images: [UIImage] = [] {
        didSet {
            set(images: images)
        }
    }
    private let itemSpacing: CGFloat = 5
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {

        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    func set(images: [UIImage]) {
        stackView.arrangedSubviews.forEach { view in
            view.removeFromSuperview()
        }
        
        for (index, image) in images.enumerated() {
            stackView.addArrangedSubview( CarouselImageView(image: image, delete: { self.deletionIndex = index }) )
        }
    }
}
