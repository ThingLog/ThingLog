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
        tableViewBottomSafeAnchorConstraint = tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        tableViewBottomSafeAnchorConstraint?.isActive = false
        tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor)
        tableViewBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.register(CommentTableCell.self, forCellReuseIdentifier: CommentTableCell.reuseIdentifier)
    }

    func setupCommentInputView() {
        commentInputViewBottomConstraint = commentInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        commentInputViewBottomConstraint?.isActive = true

        NSLayoutConstraint.activate([
            commentInputView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            commentInputView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // MARK: - Bind
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
                    self.setupTableViewBottomInset(height: height, duration: duration)
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
                    self.setupTableViewBottomInset(height: 0, duration: duration)
                }
            }.disposed(by: disposeBag)
    }

    // MARK: - Support Method for setup, bind
    /// TableView 하단에 여백을 지정한다.
    /// - Parameter height: 테이블 뷰 하단에 들어갈 높이
    private func setupTableViewBottomInset(height: CGFloat, duration: TimeInterval) {
        var inset: UIEdgeInsets = self.tableView.contentInset
        inset.bottom = height
        UIView.animate(withDuration: duration) {
            self.tableView.contentInset = inset
        }
        inset = tableView.verticalScrollIndicatorInsets
        inset.bottom = height
        UIView.animate(withDuration: duration) {
            self.tableView.scrollIndicatorInsets = inset
        }
    }

    /// CommentInputView의 하단 constant를 설정한다.
    func setupCommentInputViewBottomConstraint(height: CGFloat, duration: TimeInterval) {
        let bottomInset: CGFloat = view.safeAreaInsets.bottom
        if height == 0 && bottomInset != 0 {
            commentInputViewBottomConstraint?.constant = -height
        } else {
            commentInputViewBottomConstraint?.constant = -height + bottomInset
        }

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}
