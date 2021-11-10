//
//  DropDownView.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/10.
//

import UIKit

import RxCocoa
import RxSwift

/// 게시물 화면에서 수정, 삭제를 표시하기 위한 드롭다운 메뉴 뷰
/// [이미지](https://www.notion.so/DropDownView-2dce4c36bb5b4748b6c1b17b9e599813)
final class DropDownView: UIView {
    // MARK: - View Properties
    let button: UIButton = {
        let button: UIButton = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(SwiftGenIcons.moreButton.image, for: .normal)
        button.sizeToFit()
        return button
    }()

    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Properties
    var items: [String] = ["수정", "삭제"]
    var isShowDropDown: Bool = false {
        didSet {
            showDropDownView(isShowDropDown)
        }
    }
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var tableViewHeight: CGFloat = 0
    private let disposeBag: DisposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupBinding()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
    }

    private func setupView() {
        addSubviews(button, tableView)

        setupButton()
        setupTableView()
    }

    private func setupBinding() {
        button.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.isShowDropDown.toggle()
                self.showDropDownView(self.isShowDropDown)
            }.disposed(by: disposeBag)
    }

    private func showDropDownView(_ bool: Bool) {
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut) {
            self.tableViewHeightConstraint?.constant = bool ? self.tableViewHeight : 0
            self.superview?.layoutIfNeeded()
        }
    }
}

// MARK: - Setup
extension DropDownView {
    private func setupButton() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupTableView() {
        superview?.bringSubviewToFront(tableView)

        tableViewHeight = CGFloat(items.count * 44)
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.widthAnchor.constraint(equalToConstant: 64),
        ])

        tableView.rowHeight = 44
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }
}
