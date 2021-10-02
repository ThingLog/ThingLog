//
//  PostType.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/23.
//

import CoreData
import Foundation

enum PageType: Int16 {
    case bought = 0
    case wish = 1
    case gift = 2
}

struct PostType {
    let identifier: UUID = UUID()
    let isDelete: Bool
    let type: PageType
}

extension PostType {
    func toEntity(in context: NSManagedObjectContext) -> PostTypeEntity {
        let entity: PostTypeEntity = PostTypeEntity(context: context)
        entity.identifier = identifier
        entity.isDelete = isDelete
        entity.pageType = type
        return entity
    }
}
