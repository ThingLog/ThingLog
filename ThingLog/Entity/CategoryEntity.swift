//
//  CategoryEntity.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/29.
//

import CoreData
import Foundation

extension CategoryEntity {
    func toModel() -> Category {
        Category(title: self.title ?? "", identifier: self.identifier ?? UUID())
    }
}
