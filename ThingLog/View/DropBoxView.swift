//
//  DropBoxView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/29.
//

import RxSwift
import UIKit

/// 선택시 하단으로 드롭형태로 나타나는 View이다.
/// ⚠️DropBoxView는 자신이 부모 뷰 계층구조에 속한 이후에 addSubView를 해야한다.
final class DropBoxView: UIView {
    // MARK: - View
    var titleButton: InsetButton = {
        let button: InsetButton = InsetButton()
        button.setTitleColor(SwiftGenColors.black.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body3
        button.setImage(SwiftGenAssets.chevronDown.image, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 2)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        return button
    }()
    
    private var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.backgroundColor = SwiftGenColors.white.color
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.clipsToBounds = true
        tableView.showsVerticalScrollIndicator = false 
        return tableView
    }()
    
    // MARK: - Properties
    var filterType: FilterType
    // TableView를 외부 View에 추가하기 위해 필요한 UIView 프로퍼티
    private var superView: UIView?
    private var isShowingDropBox: Bool = false
    private let tableViewCellHeight: CGFloat = 28
    private var maxTableViewHeight: CGFloat {
        if filterType.list.count >= 4 {
            return tableViewCellHeight * 4
        } else {
            return tableViewCellHeight * CGFloat(filterType.list.count)
        }
    }
    private var tableViewHeightConstant: NSLayoutConstraint?
    private lazy var selectedIndexPath: IndexPath = {
        guard let index: Int = filterType.list.firstIndex(of: filterType.defaultValue) else {
            return IndexPath(row: 0, section: 0)
        }
        return IndexPath(row: index, section: 0)
    }()
    
    var selectFilterTypeSubject: PublishSubject = PublishSubject<(FilterType, String)>()
    
    // MARK: - Init
    init(type: FilterType, superView: UIView? = nil) {
        self.filterType = type
        self.superView = superView
        super.init(frame: .zero)
        updateView(title: type.defaultValue)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.filterType = .latest
        super.init(coder: coder)
    }
    
    override func didMoveToSuperview() {
        setupTableView()
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = SwiftGenColors.white.color
        addSubview(titleButton)
        superView?.addSubview(tableView)
        bringSubviewToFront(tableView)
        tableViewHeightConstant = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstant?.isActive = true
        NSLayoutConstraint.activate([
            titleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleButton.topAnchor.constraint(equalTo: topAnchor),
            titleButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupTableView() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: bottomAnchor, constant: 1)
        ])
        tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .top)
    }
}

extension DropBoxView {
    private func updateView(title: String) {
        titleButton.setTitle(title, for: .normal)
    }
    
    @objc
    func clickButton() {
        self.titleButton.imageView?.contentMode = .center
        UIView.animate(withDuration: 0.1) {
            self.titleButton.imageView?.transform = self.isShowingDropBox ? .identity : CGAffineTransform(rotationAngle: .pi)
            self.isShowingDropBox.toggle()
        } completion: { _  in
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.tableViewHeightConstant?.constant = self.isShowingDropBox ? self.maxTableViewHeight : 0
                self.superView?.layoutIfNeeded()
            }
        }
    }
}

extension DropBoxView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterType.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = SwiftGenColors.white.color
        cell.textLabel?.text = filterType.list[indexPath.row]
        cell.textLabel?.font = selectedIndexPath == indexPath ? UIFont.Pretendard.title3 : UIFont.Pretendard.body3
        cell.textLabel?.textColor = selectedIndexPath == indexPath ? SwiftGenColors.black.color : SwiftGenColors.gray4.color
        return cell
    }
}

extension DropBoxView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 기존에 선택된 cell의 강조를 풀어준다.
        if let cell: UITableViewCell = tableView.cellForRow(at: selectedIndexPath) {
            cell.textLabel?.font = UIFont.Pretendard.body3
            cell.textLabel?.textColor = SwiftGenColors.gray4.color
        }
        selectedIndexPath = indexPath
        
        // 현재 선택된 cell을 강조한다.
        if let cell: UITableViewCell = tableView.cellForRow(at: selectedIndexPath) {
            cell.textLabel?.font = UIFont.Pretendard.title3
            cell.textLabel?.textColor = SwiftGenColors.black.color
        }
        let title: String = filterType.list[indexPath.row]
        updateView(title: title)
        selectFilterTypeSubject.onNext((filterType, title))
    }
}
