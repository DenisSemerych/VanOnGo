//
//  ImageContainer.swift
//  TestTask
//
//  Created by Денис Семерич on 17.08.2021.
//

import UIKit
import TLPhotoPicker

protocol ImageContainer {
    var image: UIImage? { get }
}

struct TLImageContainer: ImageContainer {
    var image: UIImage? {
        return asset.fullResolutionImage
    }
    
    private let asset: TLPHAsset
    
    init(asset: TLPHAsset) {
        self.asset = asset
    }
}
