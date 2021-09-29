//
//  FilterType.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/28.
//

import Foundation

/// 모아보기 - 상단 탭을 클릭할 시 각 탭마다 필요한 드롭박스에 필요한 데이터들을 정의한 객체다.
enum FilterType {
    case preference, latest, year, month
    
    var list: [String] {
        switch self {
        case .latest:
            return ["최신순", "오래된 순"]
        case .month:
            return Array(1...12).map { String($0) + "월" }
        case .year:
            return Array(2_000...3_000).map { String($0) + "년" }
        case .preference:
            return ["높은순", "낮은순"]
        }
    }
    
    var defaultValue: String {
        switch self {
        case .month:
            let curDate: Date = Date()
            return curDate.stringMonth() + "월"
        case .year:
            let curDate: Date = Date()
            return curDate.stringYear() + "년"
        default:
            return list[0]
        }
    }
}
