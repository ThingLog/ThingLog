//
//  PostEntity+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/25.
//

import CoreData
import Foundation
import UIKit.UIImage

extension PostEntity {
    func update(with post: Post, in context: NSManagedObjectContext) {
        self.title = post.title
        self.price = Int64(post.price)
        self.purchasePlace = post.purchasePlace
        self.contents = post.contents
        self.giftGiver = post.giftGiver
        self.isLike = post.isLike
        self.postType?.pageType = post.postType.type
        self.rating?.scoreType = post.rating.score
        if let categories: NSSet = self.categories {
            self.removeFromCategories(categories)
        }
        post.categories.forEach { [weak self] category in
            guard let self = self else { return }
            let categoryEntity: CategoryEntity = category.toEntity(in: context)
            self.addToCategories(categoryEntity)
        }
        self.deleteDate = post.deleteDate
    }

    /// 특정 인덱스에 이미지를 반환한다.
    func getImage(at index: Int) -> UIImage? {
        guard let attachments: [AttachmentEntity] = self.attachments?.allObjects as? [AttachmentEntity],
           let imageData: Data = attachments[index].imageData?.originalImage else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
