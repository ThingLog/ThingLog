//
//  PostEntity+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/25.
//

import CoreData
import Foundation

extension PostEntity {
    func update(with post: Post, in context: NSManagedObjectContext) {
        self.title = post.title
        self.price = Int16(post.price)
        self.purchasePlace = post.purchasePlace
        self.contents = post.contents
        self.isLike = post.isLike
        self.type?.pageType = post.type.type
        self.rating?.scoreType = post.rating.score
    }
}
