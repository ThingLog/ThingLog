//
//  CropImage.swift
//  ThingLog
//
//  Created by 이지원 on 2021/12/11.
//

import UIKit

struct ImageEditInfo {
    var indexPath: IndexPath
    var image: UIImage?
    var cropImage: UIImage?
    var contentOffset: CGPoint?
    var zoomScale: CGFloat?

    init(indexPath: IndexPath, image: UIImage?, cropImage: UIImage? = nil, contentOffset: CGPoint? = nil, zoomScale: CGFloat? = nil) {
        self.indexPath = indexPath
        self.image = image
        self.cropImage = cropImage
        self.contentOffset = contentOffset
        self.zoomScale = zoomScale
    }
}
