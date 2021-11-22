//
//  CommentCoordinator.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/22.
//

import Foundation

/// 댓글 화면으로 이동하기 위한 메소드를 정의한 Coordinator 프로토콜
protocol CommentCoordinatorProtocol: Coordinator {
    /// `CommentViewController`로 이동한다. `CommentViewController`에서 데이터를 표시하기 위해 `PostEntity`가 필요하다.
    func showCommentViewController(with entity: PostEntity)
}

extension CommentCoordinatorProtocol {
    func showCommentViewController(with entity: PostEntity) {
        // TODO: CommentViewController로 대체
        let commentViewController: TestCommentViewController = TestCommentViewController(postEntity: entity)
        navigationController.pushViewController(commentViewController, animated: true)
    }
}
