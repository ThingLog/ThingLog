//
//  CommentViewController+DataSource.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/13.
//

import UIKit

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (viewModel.contents.isEmpty ? 0 : 1) + viewModel.commentCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && viewModel.contents.isNotEmpty {
            return configureContentCell(with: indexPath)
        } else {
            return configureCommentCell(with: indexPath)
        }
    }
}

extension CommentViewController {
    private func configureContentCell(with indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)

        cell.textLabel?.text = viewModel.contents
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont.Pretendard.body1
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = SwiftGenColors.primaryBlack.color

        return cell
    }

    private func configureCommentCell(with indexPath: IndexPath) -> CommentTableCell {
        guard let cell: CommentTableCell = tableView.dequeueReusableCell(withIdentifier: CommentTableCell.reuseIdentifier, for: indexPath) as? CommentTableCell else {
            return CommentTableCell()
        }

        let commentIndex: Int = viewModel.contents.isEmpty ? indexPath.row : indexPath.row - 1

        cell.delegate = self
        cell.textView.text = viewModel.getComment(at: commentIndex)
        cell.dateLabel.text = viewModel.getCommentDate(at: commentIndex)

        cell.toolbarCancleCallback = { [weak self] in
            cell.isEditable = false
            self?.hideCommentInputView(false)
            self?.tableView.reloadData()
        }

        cell.modifyButton.rx.tap
            .bind { [weak self] in
                cell.isEditable.toggle()
                cell.isEditable ? cell.textView.becomeFirstResponder() : cell.textView.resignFirstResponder()
                if !cell.isEditable {
                    self?.viewModel.updateComment(at: commentIndex,
                                                  text: cell.textView.text)
                }
                self?.hideCommentInputView(cell.isEditable)
            }.disposed(by: cell.disposeBag)

        cell.deleteButton.rx.tap
            .bind { [weak self] in
                if cell.isEditable {
                    cell.isEditable.toggle()
                    cell.textView.resignFirstResponder()
                    self?.tableView.reloadData()
                } else {
                    self?.showRemoveCommentAlert(at: commentIndex)
                }
                self?.hideCommentInputView(cell.isEditable)
            }.disposed(by: cell.disposeBag)

        return cell
    }
}

extension CommentViewController: TextViewCellDelegate {
    func updateTextViewHeight() {
        DispatchQueue.main.async { [weak tableView] in
            tableView?.beginUpdates()
            tableView?.endUpdates()
            tableView?.layoutIfNeeded()
        }
    }
}
