//
//  ResultCollectionSection.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/04.
//

import Foundation

/// 검색화면 - 검색결과에 따른 CollectionView로 보여줄 때 각 섹션에 해당하는 데이터를 추상화한 Enum 타입이다.
enum ResultCollectionSection: Int, CaseIterable {
    case category = 0
    case postTitle = 1
    case contents = 2
    case gift = 3
    case place = 4
    
    var section: Int {
        self.rawValue
    }
    
    var headerTitle: String {
        switch self {
        case .category:
            return "카테고리"
        case .postTitle:
            return "물건이름"
        case .contents:
            return "글 내용"
        case .gift:
            return "선물 준 사람"
        case .place:
            return "구매처/판매처"
        }
    }
}
