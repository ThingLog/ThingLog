//
//  CategoryViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/13.
//

import CoreData
import UIKit

import RxCocoa
import RxSwift

/// 글쓰기 화면에서 카테고리 추가, 선택할 때 사용된다.
final class CategoryViewController: UIViewController {
    // MARK: - View Properties
    private let successButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(SwiftGenColors.black.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body1
        return button
    }()
    private let textField: UITextField = {
        let textField: UITextField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "카테고리를 만들어보세요!"
        textField.returnKeyType = .done
        return textField
    }()
    private let bottomLineView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = SwiftGenColors.gray5.color
        return view
    }()
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        return tableView
    }()

    // MARK: - Properties
    var coordinator: Coordinator?
    private lazy var repository: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: self)
    private let disposeBag: DisposeBag = DisposeBag()
    private let leadingTrailingConstant: CGFloat = 18.0
    private let topBottomConstant: CGFloat = 12.0
    private var selectedCategoryIndexPaths: Set<IndexPath> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = SwiftGenColors.white.color
        setupNavigationBar()
        setupView()
        setupBinding()
        setupToolbar()
    }

    private func setupNavigationBar() {
        setupBaseNavigationBar()

        let logoView: LogoView = LogoView("카테고리")
        navigationItem.titleView = logoView

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: SwiftGenAssets.back.image.withRenderingMode(.alwaysOriginal),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapBackButton))

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: successButton)
    }

    private func setupView() {
        setupTextField()
        setupBottomLineView()
        setupTableView()
    }

    private func setupBinding() {
        successButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                // 선택한 카테고리 IndexPath를 WriteViewModel에게 전달한다.
                NotificationCenter.default.post(name: .passToSelectedCategoryIndexPaths,
                                                object: nil,
                                                userInfo: [Notification.Name.passToSelectedCategoryIndexPaths: self.selectedCategoryIndexPaths])
                // 선택한 카테고리 IndexPath와 Category를 WriteCategoryTableCell에게 전달한다.
                NotificationCenter.default.post(name: .passToSelectedIndexPathsWithCategory,
                                                object: nil,
                                                userInfo: [Notification.Name.passToSelectedIndexPathsWithCategory: self.selectedIndexPathWithCategory()])
                self.coordinator?.back()
            }.disposed(by: disposeBag)
    }

    private func setupToolbar() {
        let keyboardToolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        keyboardToolBar.barStyle = .default
        let cancleButton: UIButton = {
            let button: UIButton = UIButton()
            button.titleLabel?.font = UIFont.Pretendard.title2
            button.setTitle("취소", for: .normal)
            button.setTitleColor(SwiftGenColors.systemBlue.color, for: .normal)
            button.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
            return button
        }()
        let cancleBarButton: UIBarButtonItem = UIBarButtonItem(customView: cancleButton)
        cancleBarButton.tintColor = SwiftGenColors.black.color
        keyboardToolBar.barTintColor = SwiftGenColors.gray6.color
        keyboardToolBar.items = [cancleBarButton, UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)]
        keyboardToolBar.sizeToFit()
        textField.inputAccessoryView = keyboardToolBar
    }

    @objc
    private func didTapBackButton() {
        coordinator?.back()
    }

    @objc
    private func dismissKeyboard() {
        textField.resignFirstResponder()
    }

    /// 선택한 카테고리를 IndexPath와 함께 Category 객체로 변환해서 반환한다.
    private func selectedIndexPathWithCategory() -> [(IndexPath, Category)] {
        var categories: [(IndexPath, Category)] = []
        selectedCategoryIndexPaths.forEach { indexPath in
            let categoryEntity: CategoryEntity = repository.fetchedResultsController.object(at: indexPath)
            categories.append((indexPath, categoryEntity.toModel()))
        }
        return categories
    }
}

// MARK: - Setup
extension CategoryViewController {
    private func setupTextField() {
        view.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leadingTrailingConstant),
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topBottomConstant),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -leadingTrailingConstant)
        ])

        textField.delegate = self
    }

    private func setupBottomLineView() {
        view.addSubview(bottomLineView)

        NSLayoutConstraint.activate([
            bottomLineView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomLineView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: topBottomConstant),
            bottomLineView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomLineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: bottomLineView.bottomAnchor, constant: topBottomConstant),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RoundLabelWithButtonTableCell.self, forCellReuseIdentifier: RoundLabelWithButtonTableCell.reuseIdentifier)
        tableView.allowsMultipleSelection = true
    }
}

// MARK: - TableView Delegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RoundLabelWithButtonTableCell else {
            return
        }

        selectedCategoryIndexPaths.insert(indexPath)
        cell.isSelectedCategory.toggle()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RoundLabelWithButtonTableCell else {
            return
        }

        selectedCategoryIndexPaths.remove(indexPath)
        cell.isSelectedCategory.toggle()
    }
}

// MARK: - TableView DataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repository.fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: RoundLabelWithButtonTableCell = tableView.dequeueReusableCell(withIdentifier: RoundLabelWithButtonTableCell.reuseIdentifier, for: indexPath) as? RoundLabelWithButtonTableCell else {
            return UITableViewCell()
        }

        configureCell(cell, at: indexPath)

        return cell
    }

    private func configureCell(_ cell: RoundLabelWithButtonTableCell, at indexPath: IndexPath) {
        let category: CategoryEntity = repository.fetchedResultsController.object(at: indexPath)

        cell.configure(name: category.title ?? "")

        if selectedCategoryIndexPaths.contains(indexPath) {
            cell.isSelectedCategory = true
        } else {
            cell.isSelectedCategory = false
        }
    }
}

extension CategoryViewController: UITextFieldDelegate {
    /// 키보드에서 완료 버튼을 누르면 텍스트 필드에 입력한 내용을 Core Data Category에 저장한다.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let name: String = textField.text else {
            return false
        }

        repository.create(Category(title: name)) { result in
            switch result {
            case .success:
                textField.text = ""
                textField.sendActions(for: .valueChanged)
                textField.resignFirstResponder()
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }

        return true
    }
}

extension CategoryViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
