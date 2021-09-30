//
//  Post.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/22.
//

import CoreData
import Foundation

/// Post
/// 성능 상의 이유로 NSManagedObjectContext를 계속 가지고 있는 NSManagedObject 보다는 Context가 없는 모델 객체를 사용하는 것이 올바르다고 판단하여 별도의 Model 객체가 필요함
struct Post {
    let identifier: UUID = UUID()
    var title: String
    var price: Int
    var purchasePlace: String?
    var contents: String?
    var isLike: Bool

    // MARK: Relationship
    let postType: PostType
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
        entity.postType = postType.toEntity(in: context)
        entity.isLike = isLike
        entity.rating = rating.toEntity(in: context)
        categories.forEach { category in
            entity.addToCategories(category.toEntity(in: context))
        }
        return entity
    }
}
