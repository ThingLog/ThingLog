//
//  WriteViewController+DataSource.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/09.
//

import UIKit

// MARK: - DataSource
extension WriteViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        WriteViewModel.Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemCount[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dequeueAndConfigureCell(for: indexPath, from: tableView)
    }
}

extension WriteViewController {
    private func dequeueAndConfigureCell(for indexPath: IndexPath, from tableView: UITableView) -> UITableViewCell {
        guard let section: WriteViewModel.Section = .init(rawValue: indexPath.section) else {
            fatalError("Section index out of range")
        }
        let identifier: String = section.cellIdentifier()
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        switch section {
        case .image:
            if let imageCell: WriteImageTableCell = cell as? WriteImageTableCell {
                configureImageTableCell(imageCell)
            }
        case .category:
            if let categoryCell: WriteCategoryTableCell = cell as? WriteCategoryTableCell {
                configureCategoryTableCell(categoryCell)
            }
        case .type:
            if let typeCell: WriteTextFieldCell = cell as? WriteTextFieldCell {
                configureTextFieldTableCell(typeCell, with: indexPath)
            }
        case .rating:
            if let ratingCell: WriteRatingCell = cell as? WriteRatingCell {
                configureRatingTableCell(ratingCell)
            }
        case .contents:
            if let contentCell: WriteTextViewCell = cell as? WriteTextViewCell {
                configureTextViewTableCell(contentCell, with: indexPath)
            }
        }

        return cell
    }

    private func configureImageTableCell(_ cell: WriteImageTableCell) {
        cell.coordinator = coordinator
        cell.thumbnailImages = selectedImages
    }

    private func configureCategoryTableCell(_ cell: WriteCategoryTableCell) {
        cell.indicatorButtonDidTappedCallback = { [weak self] in
            self?.coordinator?.showCategoryViewController()
        }
    }

    private func configureTextFieldTableCell(_ cell: WriteTextFieldCell, with indexPath: IndexPath) {
        cell.configure(keyboardType: viewModel.typeInfo[indexPath.row].keyboardType,
                       placeholder: viewModel.typeInfo[indexPath.row].placeholder)
        cell.isEditingSubject
            .bind { [weak self] _ in
                self?.scrollToCurrentRow(at: indexPath)
            }.disposed(by: cell.disposeBag)
        cell.textValueSubject
            .bind { [weak self] text in
                self?.viewModel.typeValues[indexPath.row] = text
            }.disposed(by: cell.disposeBag)
    }

    private func configureRatingTableCell(_ cell: WriteRatingCell) {
        cell.selectRatingBlock = { [weak self] in
            self?.viewModel.rating = cell.currentRating
            self?.view.endEditing(true)
        }
    }

    private func configureTextViewTableCell(_ cell: WriteTextViewCell, with indexPath: IndexPath) {
        cell.delegate = self
        cell.textView.rx.didBeginEditing
            .bind { [weak self] in
                self?.scrollToCurrentRow(at: indexPath)
            }.disposed(by: cell.disposeBag)
        cell.textView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                self?.viewModel.contents = text
            }).disposed(by: cell.disposeBag)
    }
}
