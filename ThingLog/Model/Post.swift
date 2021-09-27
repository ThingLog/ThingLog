//
//  Post.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/22.
//

import CoreData
import Foundation

struct Post {
    let identifier: UUID = UUID()
    var title: String
    var price: Int
    var purchasePlace: String?
    var contents: String?
    var isLike: Bool

    // MARK: Relationship
    let type: PostType
    let rating: Rating
    let categories: [Category]
    let attachments: [Attachment]
    let comments: [Comment]?
}

extension Post {
    func toEntity(in context: NSManagedObjectContext) -> PostEntity {
        let entity: PostEntity = .init(context: context)
        entity.identifier = identifier
        entity.title = title
        entity.price = Int16(price)
        entity.purchasePlace = purchasePlace
        entity.contents = contents
        entity.type = type.toEntity(in: context)
        entity.isLike = isLike
        entity.rating = rating.toEntity(in: context)
        return entity
    }
}
