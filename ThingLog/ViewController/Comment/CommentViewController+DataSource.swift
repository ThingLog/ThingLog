//
//  CommentViewController+DataSource.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/13.
//

import UIKit

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: 실제 데이터 바인딩 1 = 본문, 10 = 댓글
        1 + 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return configureContentCell(with: indexPath)
        } else {
            return configureCommentCell(with: indexPath)
        }
    }
}

extension CommentViewController {
    private func configureContentCell(with indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)

        cell.textLabel?.text = """
        Complaint that PorchCam can't pick up voices/speech when there's a loud fan running or other background noise (like a storm, etc.)
        Complaint that PorchCam can't pick up voices/speech when there's a loud fan running or other background noise (like a storm, etc.)Complaint that PorchCam can't pick up voices/speech when there's a loud fan running or other background noise (like a storm,
        """
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

        cell.delegate = self
        cell.textView.text = "테스트"

        cell.toolbarCancleCallback = { [weak self] in
            cell.isEditable = false
            self?.hideCommentInputView(false)
        }

        cell.modifyButton.rx.tap
            .bind { [weak self] in
                cell.isEditable.toggle()
                cell.textView.isEditable ? cell.textView.becomeFirstResponder() : cell.textView.resignFirstResponder()
                self?.hideCommentInputView(cell.isEditable)
            }.disposed(by: cell.disposeBag)

        cell.deleteButton.rx.tap
            .bind { [weak self] in
                if cell.isEditable {
                    cell.isEditable.toggle()
                    cell.textView.resignFirstResponder()
                } else {
                    // TODO: 삭제 기능
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
