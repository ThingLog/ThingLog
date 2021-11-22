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

        let repository: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
        let item: PostEntity = viewModel.fetchedResultsController.object(at: indexPath)

        cell.configure(with: item)
        cell.likeButton.rx.tap
            .bind {
                item.isLike.toggle()
                repository.update(item) { result in
                    switch result {
                    case .success:
                        cell.likeButton.isSelected = item.isLike
                    case .failure(let error):
                        fatalError("\(#function): \(error.localizedDescription)")
                    }
                }
            }.disposed(by: cell.disposeBag)

        return cell
    }
}
