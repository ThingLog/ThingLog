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

    /// DropDownView 외부에서 터치가 발생할 경우 DropDown를 닫기 위한 임시 View
    private let outsideTouchDetectView: IgnoreTouchView = {
        let touchDetectView: IgnoreTouchView = IgnoreTouchView(frame: UIScreen.main.bounds)
        touchDetectView.isUserInteractionEnabled = true
        return touchDetectView
    }()

    // MARK: - Properties
    var items: [String] = ["수정", "삭제"]
    /// DropDown이 보여지고 있는 지 여부를 나타내는 프로퍼티
    var isShowDropDown: Bool = false {
        didSet {
            showDropDownView(isShowDropDown)
            addOutsideTouchDetectView(isShowDropDown)
        }
    }
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var tableViewHeight: CGFloat = 0
    private var tableViewWidth: CGFloat = 0
    private var superView: UIView?
    private let disposeBag: DisposeBag = DisposeBag()

    init(superView: UIView? = nil, dropDownWidth: CGFloat = 64.0) {
        self.superView = superView
        self.tableViewWidth = dropDownWidth
        super.init(frame: .zero)
        setupView()
        setupBinding()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
        setupBinding()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupView()
        setupBinding()
    }

    private func setupView() {
        addSubviews(button)
        superView?.addSubview(tableView)
        bringSubviewToFront(tableView)

        setupButton()
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupTableView()
    }

    private func setupBinding() {
        bindButton()
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
        tableViewHeight = CGFloat(items.count * 44)
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: button.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.widthAnchor.constraint(equalToConstant: tableViewWidth)
        ])

        tableView.rowHeight = 44
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
    }
}

// MARK: - Bind
extension DropDownView {
    private func bindButton() {
        button.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.isShowDropDown.toggle()
                self.superView?.bringSubviewToFront(self.tableView)
                self.superView?.layoutIfNeeded()
            }.disposed(by: disposeBag)
    }
}

// MARK: - Private
extension DropDownView {
    /// DropDownView를 숨김/표시 처리한다.
    /// - Parameter bool: 표시하는 경우 true, 숨기는 경우 false
    private func showDropDownView(_ bool: Bool) {
        UIView.animate(withDuration: 0.35,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut) {
            self.tableViewHeightConstraint?.constant = bool ? self.tableViewHeight : 0
            self.superView?.layoutIfNeeded()
        }
    }

    /// DropDownView가 열려있는 상태에서 외부를 터치할 경우에 DropDownView를 닫히도록 하기 위하여 outsideTouchDetectView를 추가하는 메서드다.
    /// - Parameter bool: 추가하는 경우에 true를 넣는다.
    private func addOutsideTouchDetectView(_ bool: Bool) {
        if bool == false {
            outsideTouchDetectView.removeFromSuperview()
            return
        }
        superView?.addSubview(outsideTouchDetectView)
        outsideTouchDetectView.executeClosure = { [weak self] in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.15) {
                DispatchQueue.main.async {
                    if self?.outsideTouchDetectView.superview != nil {
                        self?.isShowDropDown.toggle()
                        self?.outsideTouchDetectView.removeFromSuperview()
                    }
                }
            }
        }
    }
}
