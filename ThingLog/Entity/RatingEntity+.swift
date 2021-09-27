//
//  RatingEntity+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/23.
//

import CoreData
import Foundation

extension RatingEntity {
    var scoreType: ScoreType {
        get {
            ScoreType(rawValue: score) ?? .good
        }
        set {
            score = newValue.rawValue
        }
    }
}
