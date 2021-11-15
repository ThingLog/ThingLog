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
            return SwiftGenIcons.buyVer1.image.withTintColor(SwiftGenColors.primaryBlack.color)
        case .gift:
            return SwiftGenIcons.giftVer1.image.withTintColor(SwiftGenColors.primaryBlack.color)
        case .wish:
            return SwiftGenIcons.wishVer1.image.withTintColor(SwiftGenColors.primaryBlack.color)
        }
    }
}
