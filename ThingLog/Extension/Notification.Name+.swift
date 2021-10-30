//
//  Notification.Name+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/30.
//

import Foundation

extension Notification.Name {
    /// 선택한 카테고리 IndexPaths를 전달할 때 사용한다.
    static let passToSelectedCategoryIndexPaths: Notification.Name = Notification.Name("passToSelectedCategoryIndexPaths")
    /// 선택한 카테고리의 IndexPaths와 Category를 전달할 때 사용한다.
    static let passToSelectedIndexPathsWithCategory: Notification.Name = Notification.Name("passToSelectedIndexPathsWithCategory")
    /// 삭제한 카테고리의 IndexPath를 전달할 때 사용한다.
    static let removeSelectedCategory: Notification.Name = Notification.Name("removeSelectedCategory")
}
