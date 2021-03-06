//
//  PostCoordinator.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import Foundation

protocol PostCoordinatorProtocol: PhotoCardCoordinatorProtocol, CommentCoordinatorProtocol, WriteCoordinatorProtocol {
    /// `PostViewController`를 보여준다. `PostViewController`에서 데이터를 표시하기 위해 `PostViewModel`이 필요하다.
    func showPostViewController(with viewModel: PostViewModel)
}

extension PostCoordinatorProtocol {
    func showPostViewController(with viewModel: PostViewModel) {
        let postViewController: PostViewController = PostViewController(viewModel: viewModel)
        postViewController.coordinator = self
        postViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(postViewController, animated: true)
    }

    func showWriteViewController(with viewModel: WriteViewModel) {
        let writeViewController: WriteViewController = WriteViewController(viewModel: viewModel)
        writeViewController.coordinator = self
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(writeViewController, animated: true)
    }

    func dismissWriteViewController() {
        back()
    }
}
