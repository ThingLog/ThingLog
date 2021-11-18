//
//  PostViewController+DataSource.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/09.
//

import UIKit

extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: PostTableCell = tableView.dequeueReusableCell(withIdentifier: PostTableCell.reuseIdentifier, for: indexPath) as? PostTableCell else {
            return PostTableCell()
        }

        // 초기 설정
        cell.isTrash = true
        cell.isBought = true

        // 휴지통
        cell.likeButton.rx.tap
            .bind { [weak self] in
                UIView.performWithoutAnimation {
                    self?.tableView.beginUpdates()
                    cell.isTrash = true
                    cell.isBought = false
                    self?.tableView.endUpdates()
                }
            }.disposed(by: cell.disposeBag)

        // 사고싶다
        cell.commentButton.rx.tap
            .bind { [weak self] in
                UIView.performWithoutAnimation {
                    self?.tableView.beginUpdates()
                    cell.isBought = true
                    cell.isTrash = false
                    self?.tableView.endUpdates()
                }
            }.disposed(by: cell.disposeBag)

        // 그 외 default
        cell.photocardButton.rx.tap
            .bind { [weak self] in
                UIView.performWithoutAnimation {
                    self?.tableView.beginUpdates()
                    cell.isTrash = true
                    cell.isBought = true
                    self?.tableView.endUpdates()
                }
            }.disposed(by: cell.disposeBag)
        
        return cell
    }
}
