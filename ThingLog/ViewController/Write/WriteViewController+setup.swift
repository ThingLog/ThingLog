//
//  WriteViewController+setup.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/03.
//

import Photos
import UIKit

import RxCocoa
import RxSwift

extension WriteViewController {
    func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: doneButton.topAnchor)
        ])

        tableView.estimatedRowHeight = UITableView.automaticDimension

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WriteImageTableCell.self, forCellReuseIdentifier: WriteImageTableCell.reuseIdentifier)
        tableView.register(WriteCategoryTableCell.self, forCellReuseIdentifier: WriteCategoryTableCell.reuseIdentifier)
        tableView.register(WriteTextFieldCell.self, forCellReuseIdentifier: WriteTextFieldCell.reuseIdentifier)
        tableView.register(WriteRatingCell.self, forCellReuseIdentifier: WriteRatingCell.reuseIdentifier)
        tableView.register(WriteTextViewCell.self, forCellReuseIdentifier: WriteTextViewCell.reuseIdentifier)
    }

    func setupDoneButton() {
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

    /// PhotosViewController에서 전달받은 데이터 바인딩
    func bindNotificationPassSelectPHAssets() {
        NotificationCenter.default.rx
            .notification(.passSelectAssets, object: nil)
            .map { notification -> [PHAsset] in
                notification.userInfo?[Notification.Name.passSelectAssets] as? [PHAsset] ?? []
            }
            .bind { assets in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.selectedImages = self.viewModel.requestThumbnailImages(with: assets)
                }
            }.disposed(by: disposeBag)
    }

    /// 작성 완료 버튼을 눌렀을 때 데이터를 저장한다.
    func bindDoneButton() {
        doneButton.rx.tap
            .bind { [weak self] in
                self?.getCurrentValue()
            }.disposed(by: disposeBag)
    }

    func getCurrentValue() {
        let section = WriteViewModel.Section.type.rawValue
        for index in 0..<viewModel.itemCount[section] {
            let indexPath: IndexPath = IndexPath(row: index, section: section)
            if let cell = tableView.cellForRow(at: indexPath) as? WriteTextFieldCell {
                print("⚡️", cell.text)
            }
        }
    }
}
