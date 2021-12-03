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
        setupMoreMenuCallback(cell, item)
        bindTrashButton(cell, with: item)

        return cell
    }

    private func bindLikeButton(_ cell: PostTableCell, with item: PostEntity) {
        cell.likeButton.rx.tap
            .bind { [weak self] in
                guard let isDelete: Bool = item.postType?.isDelete else {
                    return
                }
                // 휴지통인 경우 복구 알럿을 띄운다. 그 외 동작은 하지 않는다.
                if isDelete {
                    self?.showRecoverAlert(with: item)
                    return
                }
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
                guard let isDelete: Bool = item.postType?.isDelete,
                      let image: UIImage = item.getImage(at: cell.currentImagePage - 1) else {
                    return
                }

                // 휴지통인 경우 복구 알럿을 띄운다. 그 외 동작은 하지 않는다.
                if isDelete {
                    self?.showRecoverAlert(with: item)
                    return
                }
                self?.coordinator?.showPhotoCardController(post: item, image: image)
            }.disposed(by: cell.disposeBag)
    }

    private func bindCommentButton(_ cell: PostTableCell, with item: PostEntity) {
        cell.commentButton.rx.tap
            .bind { [weak self] in
                guard let isDelete: Bool = item.postType?.isDelete else {
                    return
                }
                // 휴지통인 경우 복구 알럿을 띄운다. 그 외 동작은 하지 않는다.
                if isDelete {
                    self?.showRecoverAlert(with: item)
                    return
                }
                let viewModel: CommentViewModel = CommentViewModel(postEntity: item)
                self?.coordinator?.showCommentViewController(with: viewModel)
            }.disposed(by: cell.disposeBag)
    }

    private func bindCommentMoreButton(_ cell: PostTableCell, with item: PostEntity) {
        cell.commentMoreButton.rx.tap
            .bind { [weak self] in
                // 휴지통인 경우 복구 알럿을 띄운다. 그 외 동작은 하지 않는다.
                guard let isDelete: Bool = item.postType?.isDelete else {
                    return
                }

                if isDelete {
                    self?.showRecoverAlert(with: item)
                    return
                }
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

    private func setupMoreMenuCallback(_ cell: PostTableCell, _ item: PostEntity) {
        cell.moreMenuButton.modifyPostCallback = { [weak self] in
            // 휴지통인 경우 복구 알럿을 띄운다. 그 외 동작은 하지 않는다.
            guard let isDelete: Bool = item.postType?.isDelete,
                  let type: PageType = item.postType?.pageType else {
                return
            }

            if isDelete {
                self?.showRecoverAlert(with: item)
                return
            }

            let viewModel: WriteViewModel = WriteViewModel(pageType: type, modifyEntity: item)
            self?.coordinator?.showWriteViewController(with: viewModel)
        }

        cell.moreMenuButton.removePostCallback = { [weak self] in
            guard let isDelete: Bool = item.postType?.isDelete else {
                return
            }
            // 휴지통에서 삭제를 누른 경우 실제 삭제로 이어진다.
            if isDelete {
                self?.showRemoveAlert(with: item)
            } else {
                self?.showTrashPostAlert(post: item)
            }
        }
    }

    private func bindTrashButton(_ cell: PostTableCell, with item: PostEntity) {
        cell.trashActionButton.leftButton.rx.tap
            .bind { [weak self] in
                if cell.identifier == item.identifier?.uuidString ?? "" {
                    self?.showRemoveAlert(with: item)
                }
            }.disposed(by: disposeBag)

        cell.trashActionButton.rightButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                if cell.identifier == item.identifier?.uuidString ?? "" {
                    self.viewModel.repository.recover([item], completion: { result in
                        switch result {
                        case .success:
                            do {
                                try self.viewModel.fetchedResultsController.performFetch()
                                self.tableView.reloadData()
                                // 보여줄 수 있는 게시물이 없다면 이전 화면으로 돌아간다.
                                if !self.canShowPosts {
                                    self.coordinator?.back()
                                }
                            } catch {
                                print("\(#function): \(error.localizedDescription)")
                            }
                        case .failure(let error):
                            fatalError("\(#function): \(error.localizedDescription)")
                        }
                    })
                }
            }.disposed(by: disposeBag)
    }
}
