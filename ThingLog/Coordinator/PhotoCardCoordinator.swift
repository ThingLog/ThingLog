//
//  PhotoCardCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/17.
//

import Foundation
import UIKit.UIImage

protocol PhotoCardCoordinatorProtocol: SystemSettingCoordinatorProtocol {
    /// `PhotoCardViewController`를 보여준다. `PhotoCardViewController`에서 데이터를 표시하기 위해 `PostEntity`와 특정 이미지`UIImage`가 필요하다.
    func showPhotoCardController(post: PostEntity,
                                 image: UIImage)
    
}
