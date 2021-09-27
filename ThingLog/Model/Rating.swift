//
//  Rating.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/23.
//

import CoreData
import Foundation

enum ScoreType: Int16 {
    case veryPoor = 0
    case poor = 1
    case good = 2
    case veryGood = 3
    case excellent = 4
}

struct Rating {
    let identifier: UUID = UUID()
    let score: ScoreType
}

extension Rating {
    func toEntity(in context: NSManagedObjectContext) -> RatingEntity {
        let entity: RatingEntity = .init(context: context)
        entity.identifier = identifier
        entity.scoreType = score
        return entity
    }
}
