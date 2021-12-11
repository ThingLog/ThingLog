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
        dequeueAndConfigureCell(for: indexPath)
    }
}

extension WriteViewController {
    private func dequeueAndConfigureCell(for indexPath: IndexPath) -> UITableViewCell {
        guard let section: WriteViewModel.Section = .init(rawValue: indexPath.section) else {
            fatalError("Section index out of range")
        }

        switch section {
        case .image:
            return configureImageTableCell(with: indexPath)
        case .category:
            return configureCategoryTableCell(with: indexPath)
        case .type:
            return configureTextFieldTableCell(with: indexPath)
        case .rating:
            return configureRatingTableCell(with: indexPath)
        case .contents:
            return configureTextViewTableCell(with: indexPath)
        }
    }

    private func configureImageTableCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WriteImageTableCell = tableView.dequeueReusableCell(withIdentifier: WriteImageTableCell.reuseIdentifier, for: indexPath) as? WriteImageTableCell else {
            fatalError("Unable to downcast the cell in dequeueReusableCell to WriteImageTableCell")
        }

        cell.coordinator = coordinator
        cell.thumbnailSubject = viewModel.thumbnailImagesSubject

        return cell
    }

    private func configureCategoryTableCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WriteCategoryTableCell = tableView.dequeueReusableCell(withIdentifier: WriteCategoryTableCell.reuseIdentifier, for: indexPath) as? WriteCategoryTableCell else {
            fatalError("Unable to downcast the cell in dequeueReusableCell to WriteCategoryTableCell")
        }

        cell.categorySubject = viewModel.categorySubject
        cell.indicatorButtonDidTappedCallback = { [weak self] in
            guard let categories: [Category] = try? self?.viewModel.categorySubject.value() else {
                return
            }

            let entities: [CategoryEntity] = categories.map { $0.toEntity(in: CoreDataStack.shared.mainContext) }
            self?.coordinator?.showCategoryViewController(entities: entities)
        }

        return cell
    }

    private func configureTextFieldTableCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WriteTextFieldCell = tableView.dequeueReusableCell(withIdentifier: WriteTextFieldCell.reuseIdentifier, for: indexPath) as? WriteTextFieldCell else {
            fatalError("Unable to downcast the cell in dequeueReusableCell to WriteTextFieldCell")
        }

        cell.configure(keyboardType: viewModel.typeInfo[indexPath.row].keyboardType,
                       placeholder: viewModel.typeInfo[indexPath.row].placeholder,
                       text: viewModel.typeValues[indexPath.row])
        cell.isEditingSubject
            .bind { [weak self] _ in
                self?.scrollToCurrentRow(at: indexPath)
            }.disposed(by: cell.disposeBag)
        cell.textValueSubject
            .bind { [weak self] text in
                self?.viewModel.typeValues[indexPath.row] = text
            }.disposed(by: cell.disposeBag)

        return cell
    }

    private func configureRatingTableCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WriteRatingCell = tableView.dequeueReusableCell(withIdentifier: WriteRatingCell.reuseIdentifier, for: indexPath) as? WriteRatingCell else {
            fatalError("Unable to downcast the cell in dequeueReusableCell to WriteRatingCell")
        }

        cell.setCurrentRating(viewModel.rating)
        cell.selectRatingBlock = { [weak self] in
            self?.viewModel.rating = cell.currentRating
            self?.view.endEditing(true)
        }

        return cell
    }

    private func configureTextViewTableCell(with indexPath: IndexPath) -> UITableViewCell {
        guard let cell: WriteTextViewCell = tableView.dequeueReusableCell(withIdentifier: WriteTextViewCell.reuseIdentifier, for: indexPath) as? WriteTextViewCell else {
            fatalError("Unable to downcast the cell in dequeueReusableCell to WriteTextViewCell")
        }

        cell.delegate = self
        cell.textView.text = viewModel.contents.isNotEmpty ? viewModel.contents : "물건에 대한 생각이나 감정을 자유롭게 기록해보세요."
        cell.textView.textColor = viewModel.contents.isNotEmpty ? SwiftGenColors.primaryBlack.color : SwiftGenColors.gray2.color

        cell.textView.rx.didBeginEditing
            .bind { [weak self] in
                self?.scrollToCurrentRow(at: indexPath)
            }.disposed(by: cell.disposeBag)
        cell.textView.rx.text.orEmpty
            .subscribe(onNext: { [weak self] text in
                if cell.textView.textColor == SwiftGenColors.gray2.color {
                    self?.viewModel.contents = ""
                } else {
                    self?.viewModel.contents = text
                }
            }).disposed(by: cell.disposeBag)

        return cell
    }
}
