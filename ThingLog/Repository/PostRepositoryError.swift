//
//  PostRepositoryError.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/29.
//

import Foundation

enum PostRepositoryError: Error {
    case notFoundEntity
    case notFoundContext
    case failedUpdate
    case failedFetch
    case failedCreatePost
    case failedDelete
}

extension PostRepositoryError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFoundEntity:
            return "PostEntity를 찾을 수 없습니다."
        case .notFoundContext:
            return "Context를 찾을 수 없습니다."
        case .failedUpdate:
            return "PostEntity 수정을 실패했습니다."
        case .failedFetch:
            return "PostEntity 가져오기를 실패했습니다."
        case .failedCreatePost:
            return "PostEntity 생성을 실패했습니다."
        case .failedDelete:
            return "PostEntity 삭제를 실패했습니다."
        }
    }
}
