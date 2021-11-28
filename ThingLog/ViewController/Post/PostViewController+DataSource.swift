//
//  PostViewController+DataSource.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/09.
//

import UIKit

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: PostTableCell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.reuseIdentifier, for: indexPath) as? PostTableCell else {
            return PostTableCell()
        }

        let item: PostEntity = viewModel.fetchedResultsController.object(at: indexPath)
        cell.configure(with: item)

        bindLikeButton(cell, with: item)
        bindPhotocardButton(cell, with: item)
        bindCommentButton(cell, with: item)
        bindCommentMoreButton(cell, with: item)
        bindBoughtButton(cell, with: item)

        cell.moreMenuButton.modifyPostCallback = { [weak self] in
            guard let type: PageType = item.postType?.pageType else {
                fatalError("\(#function): not found page type")
            }

            let viewModel: WriteViewModel = WriteViewModel(pageType: type, modifyEntity: item)
            self?.coordinator?.showWriteViewController(with: viewModel)
        }

        cell.moreMenuButton.removePostCallback = { [weak self] in
            self?.showRemovePostAlert(post: item)
        }

        return cell
    }

    private func bindLikeButton(_ cell: PostTableCell, with item: PostEntity) {
        cell.likeButton.rx.tap
            .bind { [weak self] in
                item.isLike.toggle()
                self?.viewModel.repository.update(item) { result in
                    switch result {
                    case .success:
                        cell.likeButton.isSelected = item.isLike
                    case .failure(let error):
                        fatalError("\(#function): \(error.localizedDescription)")
                    }
                }
            }.disposed(by: cell.disposeBag)
    }

    private func bindPhotocardButton(_ cell: PostTableCell, with item: PostEntity) {
        cell.photocardButton.rx.tap
            .bind { [weak self] in
                guard let image: UIImage = item.getImage(at: cell.currentImagePage - 1) else {
                    return
                }
                self?.coordinator?.showPhotoCardController(post: item, image: image)
            }.disposed(by: cell.disposeBag)
    }

    private func bindCommentButton(_ cell: PostTableCell, with item: PostEntity) {
        cell.commentButton.rx.tap
            .bind { [weak self] in
                let viewModel: CommentViewModel = CommentViewModel(postEntity: item)
                self?.coordinator?.showCommentViewController(with: viewModel)
            }.disposed(by: cell.disposeBag)
    }

    private func bindCommentMoreButton(_ cell: PostTableCell, with item: PostEntity) {
        cell.commentMoreButton.rx.tap
            .bind { [weak self] in
                let viewModel: CommentViewModel = CommentViewModel(postEntity: item)
                self?.coordinator?.showCommentViewController(with: viewModel)
            }.disposed(by: cell.disposeBag)
    }

    private func bindBoughtButton(_ cell: PostTableCell, with item: PostEntity) {
        cell.boughtButton.rx.tap
            .bind { [weak self] in
                let viewModel: WriteViewModel = WriteViewModel(pageType: .bought,
                                                               modifyEntity: item)
                self?.coordinator?.showWriteViewController(with: viewModel)
            }.disposed(by: cell.disposeBag)
    }
}
