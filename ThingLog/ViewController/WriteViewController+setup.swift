//
//  WriteViewController+setup.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

import UIKit

extension WriteViewController {
    func setupNavigationBar() {
        if #available(iOS 15, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = SwiftGenColors.white.color
            appearance.shadowColor = .clear
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = SwiftGenColors.white.color
            navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }

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
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.estimatedRowHeight = UITableView.automaticDimension

        tableView.dataSource = self
        tableView.register(WriteImageTableCell.self, forCellReuseIdentifier: WriteImageTableCell.reuseIdentifier)
        tableView.register(WriteCategoryTableCell.self, forCellReuseIdentifier: WriteCategoryTableCell.reuseIdentifier)
        tableView.register(WriteTextFieldCell.self, forCellReuseIdentifier: WriteTextFieldCell.reuseIdentifier)
        tableView.register(WriteRatingCell.self, forCellReuseIdentifier: WriteRatingCell.reuseIdentifier)
        tableView.register(WriteTextViewCell.self, forCellReuseIdentifier: WriteTextViewCell.reuseIdentifier)

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing(sender:))))
    }

    func setupBind() {
        // 키보드가 올라왔을 때 키보드 높이만큼 하단 여백 추가
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification, object: nil)
            .map { notification -> CGFloat in
                (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
            }
            .bind { [weak self] height in
                guard let self = self else { return }
                let insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
                self.tableView.contentInset = insets
            }
            .disposed(by: disposeBag)

        // 키보드가 내려갔을 때 하단 여백 삭제
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification, object: nil)
            .bind { [weak self] _ in
                guard let self = self else { return }
                let insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.tableView.contentInset = insets
            }
            .disposed(by: disposeBag)
    }

    @objc
    func endEditing(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
}
