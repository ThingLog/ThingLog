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

        cell.moreMenuButton.modifyPostCallback = {
            // TODO: 수정 기능
        }

        cell.moreMenuButton.removePostCallback = { [weak self] in
            self?.showRemovePostAlert(post: item)
        }

        cell.photocardButton.rx.tap
            .bind { [weak self] in
                guard let image: UIImage = item.getImage(at: cell.currentImagePage) else {
                    return
                }
                self?.coordinator?.showPhotoCardController(post: item, image: image)
            }.disposed(by: cell.disposeBag)

        cell.commentButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.showCommentViewController(with: item)
            }.disposed(by: cell.disposeBag)

        cell.commentMoreButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.showCommentViewController(with: item)
            }.disposed(by: cell.disposeBag)

        return cell
    }
}
