//
//  CommentCoordinator.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/22.
//

import Foundation

/// 댓글 화면으로 이동하기 위한 메소드를 정의한 Coordinator 프로토콜
protocol CommentCoordinatorProtocol: Coordinator {
    /// `CommentViewController`로 이동한다. `CommentViewModel`이 필요하다.
    func showCommentViewController(with viewModel: CommentViewModel)
}

extension CommentCoordinatorProtocol {
    func showCommentViewController(with viewModel: CommentViewModel) {
        let commentViewController: CommentViewController = CommentViewController(viewModel: viewModel)
        commentViewController.coordinator = self
        commentViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(commentViewController, animated: true)
    }
}
