//
//  PostType+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/23.
//

import CoreData
import Foundation

extension PostTypeEntity {
    var pageType: PageType {
        get {
            PageType(rawValue: type) ?? .bought
        }
        set {
            type = newValue.rawValue
        }
    }
}
