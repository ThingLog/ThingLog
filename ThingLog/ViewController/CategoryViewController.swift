//
//  CategoryViewController.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/13.
//

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
    private let disposeBag: DisposeBag = DisposeBag()
    private let leadingTrailingConstant: CGFloat = 18.0
    private let topBottomConstant: CGFloat = 12.0
    private var selectedCategories: Set<IndexPath> = []
    
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
                // TODO: 카테고리 전달
                self?.coordinator?.back()
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

        selectedCategories.insert(indexPath)
        cell.isSelectedCategory.toggle()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RoundLabelWithButtonTableCell else {
            return
        }

        selectedCategories.remove(indexPath)
        cell.isSelectedCategory.toggle()
    }
}

// MARK: - TableView DataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: RoundLabelWithButtonTableCell = tableView.dequeueReusableCell(withIdentifier: RoundLabelWithButtonTableCell.reuseIdentifier, for: indexPath) as? RoundLabelWithButtonTableCell else {
            return UITableViewCell()
        }

        cell.configure(name: "테스트")

        if selectedCategories.contains(indexPath) {
            cell.isSelectedCategory = true
        } else {
            cell.isSelectedCategory = false
        }

        return cell
    }
}
