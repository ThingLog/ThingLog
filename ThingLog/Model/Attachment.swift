//
//  Attachment.swift
//  ThingLog
//
//  Created by 이지원 on 2021/09/24.
//

import CoreData
import Foundation
import UIKit.UIImage

struct Attachment {
    let identifier: UUID = UUID()
    let thumbnail: UIImage

    // MARK: Relationship
    let imageData: ImageData
}

extension Attachment {
    struct ImageData {
        let originalImage: UIImage
    }

    func toEntity(in context: NSManagedObjectContext) -> AttachmentEntity {
        let entity: AttachmentEntity = AttachmentEntity(context: context)
        entity.identifier = identifier
        entity.thumbnail = thumbnail.pngData()
        entity.imageData = imageData.toEntity(in: context)
        return entity
    }
}

extension Attachment.ImageData {
    func toEntity(in context: NSManagedObjectContext) -> ImageDataEntity {
        let entity: ImageDataEntity = ImageDataEntity(context: context)
        entity.originalImage = originalImage.pngData()
        return entity
    }
}
