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

    // MARK: Relationship
    var posts: [Post] = []

    init(title: String, identifier: UUID = UUID()) {
        self.identifier = identifier
        self.title = title
    }
}

extension Category {
    func toEntity(in context: NSManagedObjectContext) -> CategoryEntity {
        let repository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)
        // TODO: ! 삭제하기
        var entity: CategoryEntity!

        repository.find(with: title) { isFind, findEntity in
            if isFind, let findEntity: CategoryEntity = findEntity {
                entity = findEntity
            } else {
                let newEntity: CategoryEntity = CategoryEntity(context: context)
                newEntity.identifier = identifier
                newEntity.title = title
                entity = newEntity
            }
        }

        return entity
    }
}
