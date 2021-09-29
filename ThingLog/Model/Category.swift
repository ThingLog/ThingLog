//
//  Category.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/23.
//

import CoreData
import Foundation

struct Category {
    let identifier: UUID
    let title: String

    init(title: String, identifier: UUID = UUID()) {
        self.identifier = identifier
        self.title = title
    }
}

extension Category {
    func toEntity(in context: NSManagedObjectContext) -> CategoryEntity {
        let entity: CategoryEntity = CategoryEntity(context: context)
        entity.identifier = identifier
        entity.title = title
        return entity
    }
}
