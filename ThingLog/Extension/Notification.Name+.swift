//
//  Notification.Name+.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/28.
//

import Foundation

extension Notification.Name {
    static let selectAlbumString: String = "selectAlbum"
    static let passSelectImagesString: String = "passSelectImagesString"
    static let selectAlbum: Notification.Name = Notification.Name(selectAlbumString)
    static let passSelectImages: Notification.Name = Notification.Name(passSelectImagesString)
}
