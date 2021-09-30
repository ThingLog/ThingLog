//
//  CategoryRepositoryError.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/29.
//

import Foundation

enum CategoryRepositoryError: Error {
    case failedCreateCategory
    case failedFetch
    case failedDelete
}

extension CategoryRepositoryError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedCreateCategory:
            return "CategoryEntity 생성을 실패했습니다."
        case .failedFetch:
            return "CategoryEntity 가져오기를 실패했습니다."
        case .failedDelete:
            return "CategoryEntity 삭제를 실패했습니다."
        }
    }
}
