//
//  CommentViewModel.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/22.
//

import Foundation

final class CommentViewModel {
    // MARK: - Properties
    var postEntity: PostEntity

    // MARK: - Init
    init(postEntity: PostEntity) {
        self.postEntity = postEntity
    }
}
