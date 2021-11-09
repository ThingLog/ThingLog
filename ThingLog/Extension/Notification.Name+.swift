//
//  Notification.Name+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/30.
//

import Foundation

extension Notification.Name {
    static let selectAlbum: Notification.Name = Notification.Name("selectAlbum")
    static let passSelectAssets: Notification.Name = Notification.Name("passSelectAssets")
    /// 선택한 카테고리를 전달할 때 사용한다.
    static let passToSelectedCategories: Notification.Name = Notification.Name("passToSelectedCategories")
    /// 삭제한 카테고리의 IndexPath를 전달할 때 사용한다.
    static let removeSelectedCategory: Notification.Name = Notification.Name("removeSelectedCategory")
}