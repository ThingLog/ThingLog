//
//  TopCategoryType.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/28.
//

import Foundation

/// 모아보기 - 최상단에 있는 카테고리 탭에 필요한 데이터를 추상화한 객체다.
/// 각 탭에 대하여 필요한 `FilterType`들을 제공한다.
enum TopCategoryType {
    case total, date, category, like, preference, price
    
    var filterTypes: [FilterType] {
        switch self {
        case .like, .preference, .price:
            return [.preference]
        case .total, .category:
            return [.latest]
        case .date:
            return [.year, .month, .latest]
        }
    }
}
