//
//  Post.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/22.
//

import CoreData
import Foundation

struct Post {
    let title: String
    let price: Int
    let purchasePlace: String?
    let purchaseDate: Date?
    let contents: String?
}

extension Post {
    func toEntity(in context: NSManagedObjectContext) -> PostEntity {
        let entity: PostEntity = .init(context: context)
        entity.title = title
        entity.price = Int32(price)
        entity.purchasePlace = purchasePlace
        entity.purchaseDate = purchaseDate
        entity.contents = contents
        return entity
    }
}
