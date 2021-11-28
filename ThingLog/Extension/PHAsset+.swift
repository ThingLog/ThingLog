//
//  PHAsset+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/28.
//

import Photos
import UIKit

extension PHAsset {
    func toImage(targetSize size: CGSize,
                 contentMode: PHImageContentMode = .aspectFill,
                 options: PHImageRequestOptions? = nil,
                 completion: @escaping (UIImage?) -> Void) {
        PHImageManager.default().requestImage(for: self,
                                              targetSize: size,
                                              contentMode: contentMode,
                                              options: options) { image, _ in
            completion(image)
        }
    }
}
