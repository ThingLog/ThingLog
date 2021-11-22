//
//  CommentViewModel.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/22.
//

import CoreData
import Foundation

final class CommentViewModel {
    // MARK: - Properties
    private(set) var postEntity: PostEntity
    lazy var commentCount: Int = {
        postEntity.comments?.count ?? 0
    }()
    lazy var contents: String? = {
        postEntity.contents
    }()

    // MARK: - Init
    init(postEntity: PostEntity) {
        self.postEntity = postEntity
    }

    // MARK: - Public
    func getComment(at index: Int) -> String? {
        guard let commentEntities: [CommentEntity] = postEntity.comments?.allObjects as? [CommentEntity] else {
            return nil
        }
        return commentEntities[index].contents
    }
}
