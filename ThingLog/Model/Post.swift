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
    var giftGiver: String?
    var isLike: Bool
    var deleteDate: Date?
    let createDate: Date

    // MARK: Relationship
    var postType: PostType
    var rating: Rating
    var categories: [Category]
    var attachments: [Attachment]
    var comments: [Comment]?

    init(title: String, price: Int, purchasePlace: String?, contents: String?, giftGiver: String?, postType: PostType, rating: Rating, categories: [Category], attachments: [Attachment], comments: [Comment]? = nil, deleteDate: Date? = nil, isLike: Bool = false, createDate: Date = Date()) {
        self.title = title
        self.price = price
        self.purchasePlace = purchasePlace
        self.contents = contents
        self.giftGiver = giftGiver
        self.deleteDate = deleteDate
        self.isLike = isLike
        self.createDate = createDate
        self.postType = postType
        self.rating = rating
        self.categories = categories
        self.attachments = attachments
        self.comments = comments
    }
}

extension Post {
    func toEntity(in context: NSManagedObjectContext) -> PostEntity {
        let entity: PostEntity = .init(context: context)
        entity.identifier = identifier
        entity.title = title
        entity.price = Int64(price)
        entity.createDate = createDate
        entity.deleteDate = deleteDate
        entity.purchasePlace = purchasePlace
        entity.contents = contents
        entity.giftGiver = giftGiver
        entity.postType = postType.toEntity(in: context)
        entity.isLike = isLike
        entity.rating = rating.toEntity(in: context)
        categories.forEach { category in
            let categoryEntity: CategoryEntity = category.toEntity(in: context)
            entity.addToCategories(categoryEntity)
        }
        attachments.forEach { attachment in
            let attachmentEntity: AttachmentEntity = attachment.toEntity(in: context)
            entity.addToAttachments(attachmentEntity)
        }
        return entity
    }
}
