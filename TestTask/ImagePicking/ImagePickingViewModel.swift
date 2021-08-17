//
//  ImagePickingViewModel.swift
//  TestTask
//
//  Created by Денис Семерич on 17.08.2021.
//

import UIKit
import TLPhotoPicker

class ImagePickingViewModel: TLPhotosPickerViewControllerDelegate {
    
    private let imagesReceiveCompletion: (_ data: [ImageContainer]) -> Void
    
    init(completion: @escaping ([ImageContainer]) -> Void) {
        imagesReceiveCompletion = completion
    }
    
    func pickerViewController() -> UIViewController {
        let viewController = TLPhotosPickerViewController(withTLPHAssets: dismissPhotoPicker(withTLPHAssets:), didCancel: nil)
        
        var configure = TLPhotosPickerConfigure()
        configure.allowedVideo = false
        configure.allowedLivePhotos = false
        configure.maxSelectedAssets = 5
        
        viewController.configure = configure
    
        return viewController
    }
    
    func dismissPhotoPicker(withTLPHAssets assets: [TLPHAsset]) {
        let imagesData = assets.map { TLImageContainer(asset: $0) }
        
        imagesReceiveCompletion(imagesData)
    }
}
