//
//  WriteType.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/02.
//

import Foundation
import UIKit.UIImage

enum WriteType {
    case bought
    case wish
    case gift
}

extension WriteType {
    var image: UIImage? {
        switch self {
        case .bought:
            return SwiftGenAssets.bought.image
        case .gift:
            return SwiftGenAssets.gift.image
        case .wish:
            return SwiftGenAssets.wish.image
        }
    }
}
