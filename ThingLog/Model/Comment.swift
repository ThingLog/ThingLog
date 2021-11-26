//
//  Comment.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/24.
//

import CoreData
import Foundation

struct Comment {
    let identifier: UUID = UUID()
    let contents: String
}

extension Comment {
    func toEntity(in context: NSManagedObjectContext) -> CommentEntity {
        let entity: CommentEntity = CommentEntity(context: context)
        entity.identifier = identifier
        entity.contents = contents
        entity.createDate = Date()
        return entity
    }
}
