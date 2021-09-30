//
//  TopCategoryType.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/28.
//

import Foundation


/// 모아보기 - 최상단에 있는 카테고리 탭에 필요한 데이터를 추상화한 객체다.
/// 각 탭에 대하여 필요한 `FilterType`들을 제공한다.
enum TopCategoryType: String, CaseIterable {
    case total = "전체"
    case date = "년도"
    case category = "카테고리"
    case like = "좋아요"
    case preference = "만족도"
    case price = "가격"
    
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
