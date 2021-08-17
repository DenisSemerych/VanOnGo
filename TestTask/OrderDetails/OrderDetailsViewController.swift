//
//  OrderDetailsViewController.swift
//  TestTask
//
//  Created by Denys Semerych on 08.08.2021.
//

import UIKit
import Combine

class OrderDetailsViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: OrderDetailsViewModel
    private var bindings = Set<AnyCancellable>()
    
    private let offset: CGFloat = 18
    private let buttonHeight: CGFloat = 40
    private let carouselHeight: CGFloat = 100
    
    private let errorColor: UIColor = .red
    private let validColor: UIColor = UIColor.black.withAlphaComponent(0.5)
    
    // MARK: Outlets
    private lazy var addPhotoButton: UIButton  = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.setImage(.add, for: .normal)
        button.setTitle(self.viewModel.addPhotoText, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.layoutIfNeeded()
        button.addTarget(self, action: #selector(self.addPhoto), for: .touchUpInside)
        
        return button
    }()
    private lazy var addPhotoButtonZeroWidthConstraint: NSLayoutConstraint = addPhotoButton.widthAnchor.constraint(equalToConstant: 0)
    private lazy var addOrderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.titleLabel?.textColor = .white
        button.setTitle(viewModel.addOrderText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addOrder), for: .touchUpInside)
        
        return button
    }()
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = errorColor
        label.text = viewModel.errorText
        label.numberOfLines = 0
       
        return label
    }()
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        textView.layer.borderColor = validColor.cgColor
        textView.delegate = self
        
        textView.text = viewModel.descirptionText
        
        return textView
    }()
    private let carousel = ImageCarousel()
    
    init(viewModel: OrderDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        initLayout()
        setBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("use init(viewModel:) instead")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("use init(viewModel:) instead")
    }
    
    private func initLayout() {
        let topLabel = UILabel()
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.numberOfLines = 0
        topLabel.font = .systemFont(ofSize: 15)
        topLabel.text = viewModel.topText
        view.addSubview(topLabel)
        
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionTextView)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhotoButton)
        
        carousel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(carousel)
        
        addOrderButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addOrderButton)
        
        NSLayoutConstraint.activate([
            topLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            topLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
            topLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            
            descriptionTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                         constant: offset),
            descriptionTextView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: offset),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                          constant: -offset),
            descriptionTextView.heightAnchor.constraint(equalToConstant: buttonHeight * 5),
            
            errorLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: offset / 2),
            errorLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor),
            
            addPhotoButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: offset),
            addPhotoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            
            carousel.leadingAnchor.constraint(equalTo: addPhotoButton.trailingAnchor, constant: offset / 2),
            carousel.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: offset),
            carousel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            carousel.heightAnchor.constraint(equalToConstant: carouselHeight),
            
            addOrderButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: offset),
            addOrderButton.topAnchor.constraint(greaterThanOrEqualTo: carousel.bottomAnchor, constant: offset),
            addOrderButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -offset),
            addOrderButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -offset),
            addOrderButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
    private func setBindings() {
        
        viewModel.$canAddPhoto.sink { [weak self] canAddPhoto in
            self?.addPhotoButton.isHidden = !canAddPhoto
            self?.addPhotoButtonZeroWidthConstraint.isActive = !canAddPhoto
        }.store(in: &bindings)
        
        viewModel.$isEditing.sink { [weak self] isEditing in
            self?.addOrderButton.isHidden = !isEditing
            self?.descriptionTextView.isEditable = isEditing
        }.store(in: &bindings)
        
        NotificationCenter.default.publisher(for: UITextView.textDidChangeNotification, object: descriptionTextView)
            .map { ($0.object as? UITextView)?.text ?? "" }
            .assign(to: &viewModel.$descirptionText)
        
        viewModel.$isDescriptionValid.sink { [weak self] isValid in
            self?.errorLabel.isHidden = isValid
            self?.descriptionTextView.layer.borderColor = isValid ? self?.validColor.cgColor : self?.errorColor.cgColor
        }.store(in: &bindings)
        
        viewModel.$imagesData.sink { [weak self] imagesData in
            guard let self = self else { return }
            
            let images: [UIImage] = imagesData.compactMap { [weak self] in
                guard let self = self else { return nil }
                return $0.image?.resized(targetSize: CGSize(width: self.carouselHeight, height: self.carouselHeight))
            }
            
            self.carousel.set(images: images)
        }.store(in: &bindings)
        
        carousel.$deletionIndex.sink { [weak self] index in
            guard index != nil else { return }
            self?.viewModel.deleteImageAt(index: index!)
        }.store(in: &bindings)
    }
    
    @objc private func addOrder() {
        viewModel.addOrder()
    }
    
    @objc private func addPhoto() {
        viewModel.addPhoto()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        descriptionTextView.resignFirstResponder()
    }
}

extension OrderDetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)

        return viewModel.checkDescription(text: newText)
    }
}
