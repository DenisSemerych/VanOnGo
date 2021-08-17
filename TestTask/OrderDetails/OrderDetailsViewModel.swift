//
//  OrderDetailsViewModel.swift
//  TestTask
//
//  Created by Denys Semerych on 08.08.2021.
//

import Foundation
import Combine

protocol OrderDetailsRouting {
    func addPhoto(completion: @escaping ([ImageContainer]) -> Void)
    func orderAdded()
}

class OrderDetailsViewModel {
    
    enum Mode {
        case adding
        case viewing(order: Order)
    }
    
    private var order: Order?
    private let routing: OrderDetailsRouting
    private let storage: StorageService
    private var bindings: Set<AnyCancellable> = []
    private let maxAllowedDescriptionSymbols: Int = 200
    
    let topText = "What you planning to transfer and where from"
    let addPhotoText = "Add \nPhoto"
    let addOrderText = "Add Order"
    let errorText = "Description can`t be more then 200 symbols or empty"
    
  
    @Published var canAddPhoto: Bool
    @Published var isEditing: Bool
    @Published var isDescriptionValid: Bool
    @Published var state: Mode
    @Published var imagesData: [ImageContainer]
    @Published var descirptionText: String
    
    init(state: Mode, routing: OrderDetailsRouting, storage: StorageService = LocalStorageService()) {
        self.routing = routing
        self.state = state
        self.storage = storage
        isDescriptionValid = true
        switch state {
        case .viewing(let order):
            self.order = order
            isEditing = false
            imagesData = order.images
            descirptionText = order.description
            canAddPhoto = false
        case .adding:
            isEditing = true
            imagesData = []
            descirptionText = ""
            canAddPhoto = true
        }

        $descirptionText.sink { [weak self] in self?.checkDescription(text: $0) }.store(in: &bindings)
    }
    
    func addOrder() {
        guard checkDescription(text: descirptionText) else { return }
        
        storage.save(order: Order(name: .orderName, description: descirptionText, images: []))
        routing.orderAdded()
    }
    
    func addPhoto() {
        routing.addPhoto { [weak self] data in
            self?.imagesData = data
            self?.canAddPhoto = data.count < 5
        }
    }
    
    func deleteImageAt(index: Int) {
        guard index < imagesData.count else { return }
        
        imagesData.remove(at: index)
        canAddPhoto = imagesData.count < 5
    }
    
    @discardableResult
    func checkDescription(text: String) -> Bool {
        guard text.count >= maxAllowedDescriptionSymbols else { return true }
        
        
        isDescriptionValid = false
        return false
    }
}
