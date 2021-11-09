//
//  PostType.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/23.
//

import CoreData
import Foundation
import UIKit.UIImage

enum PageType: Int16 {
    case bought = 0
    case wish = 1
    case gift = 2
}

extension PageType {
    /// PageType에 따라 이미지를 반환한다.
    var image: UIImage? {
        switch self {
        case .bought:
            return SwiftGenIcons.buyVer1.image.withTintColor(SwiftGenColors.black.color)
        case .gift:
            return SwiftGenIcons.giftVer1.image.withTintColor(SwiftGenColors.black.color)
        case .wish:
            return SwiftGenIcons.wishVer1.image.withTintColor(SwiftGenColors.black.color)
        }
    }
}

struct PostType {
    let identifier: UUID = UUID()
    let isDelete: Bool
    let type: PageType
}

extension PostType {
    /// PostType Entity를 반환한다.
    /// - Parameter context: PostType Entity를 생성하기 위한 NSManagedObjectContext
    /// - Returns: PostType Entity를 생성한다.
    func toEntity(in context: NSManagedObjectContext) -> PostTypeEntity {
        let entity: PostTypeEntity = PostTypeEntity(context: context)
        entity.identifier = identifier
        entity.isDelete = isDelete
        entity.pageType = type
        return entity
    }
}
