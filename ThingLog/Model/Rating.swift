//
//  Rating.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/23.
//

import CoreData
import Foundation

enum ScoreType: Int16 {
    case unrated = 0
    case veryPoor = 1
    case poor = 2
    case good = 3
    case veryGood = 4
    case excellent = 5
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
