//
//  CommentViewController+setup.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/14.
//

import UIKit

import RxCocoa
import RxSwift

extension CommentViewController {
    func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor)
        ])

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.register(CommentTableCell.self, forCellReuseIdentifier: CommentTableCell.reuseIdentifier)
    }

    func setupCommentInputView() {
        commentInputViewBottomConstraint = commentInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        commentInputViewBottomConstraint?.constant = 0
        commentInputViewBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            commentInputView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            commentInputView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    /// 키보드가 올라왔을 때 commentInputView 위치 변경
    func bindKeyboardWillShow() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .map { notification -> (CGFloat, TimeInterval) in
                ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0,
                 notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0)
            }
            .bind { [weak self] height, duration in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.setupCommentInputViewBottomConstraint(height: height, duration: duration)
                }
            }.disposed(by: disposeBag)
    }

    /// 키보드가 내려갔을 때 commentInputView 위치 변경
    func bindKeyboardWillHide() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .map { notification -> TimeInterval in
                notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
            }
            .bind { [weak self] duration in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.setupCommentInputViewBottomConstraint(height: 0, duration: duration)
                }
            }.disposed(by: disposeBag)
    }

    func setupCommentInputViewBottomConstraint(height: CGFloat, duration: TimeInterval) {
        commentInputViewBottomConstraint?.constant = -height

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
