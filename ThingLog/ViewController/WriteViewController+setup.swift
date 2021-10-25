//
//  WriteViewController+setup.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

import UIKit

extension WriteViewController {
    func setupNavigationBar() {
        setupBaseNavigationBar()
        
        let logoView: LogoView = LogoView("글쓰기")
        navigationItem.titleView = logoView

        let closeButton: UIButton = {
            let button: UIButton = UIButton()
            button.setTitle("닫기", for: .normal)
            button.setTitleColor(SwiftGenColors.black.color, for: .normal)
            button.titleLabel?.font = UIFont.Pretendard.body1
            return button
        }()

        closeButton.rx.tap.bind { [weak self] in
            self?.close()
        }.disposed(by: disposeBag)

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
    }

    func setupView() {
        view.addSubview(tableView)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor),
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.estimatedRowHeight = UITableView.automaticDimension

        tableView.dataSource = self
        tableView.register(WriteImageTableCell.self, forCellReuseIdentifier: WriteImageTableCell.reuseIdentifier)
        tableView.register(WriteCategoryTableCell.self, forCellReuseIdentifier: WriteCategoryTableCell.reuseIdentifier)
        tableView.register(WriteTextFieldCell.self, forCellReuseIdentifier: WriteTextFieldCell.reuseIdentifier)
        tableView.register(WriteRatingCell.self, forCellReuseIdentifier: WriteRatingCell.reuseIdentifier)
        tableView.register(WriteTextViewCell.self, forCellReuseIdentifier: WriteTextViewCell.reuseIdentifier)
    }

    /// 키보드가 올라왔을 때 키보드 높이만큼 하단 여백 추가
    func bindKeyboardWillShow() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification, object: nil)
            .map { notification -> CGFloat in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .bind { [weak self] height in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.setupTableViewBottomInset(height)
                }
            }.disposed(by: disposeBag)
    }

    /// 키보드가 내려갔을 때 하단 여백 삭제
    func bindKeyboardWillHide() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification, object: nil)
            .bind { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.setupTableViewBottomInset(0)
                }
            }.disposed(by: disposeBag)
    }

    /// TableView 하단에 여백을 지정한다.
    /// - Parameter height: 테이블 뷰 하단에 들어갈 높이
    private func setupTableViewBottomInset(_ height: CGFloat) {
        var inset: UIEdgeInsets = self.tableView.contentInset
        inset.bottom = height
        UIView.animate(withDuration: 0.3) {
            self.tableView.contentInset = inset
        }
        inset = tableView.verticalScrollIndicatorInsets
        inset.bottom = height
        UIView.animate(withDuration: 0.3) {
            self.tableView.scrollIndicatorInsets = inset
        }
    }
}
