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
        button.setTitleColor(SwiftGenColors.primaryBlack.color, for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body3
        button.setImage(SwiftGenIcons.dropBoxArrow1.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = SwiftGenColors.primaryBlack.color
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.clipsToBounds = true
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // DropBoxView 이외에서도 터치가 발생할 경우 DropBox를 닫기 위한 임시 View이다.
    private let outsideTouchDetectView: IgnoreTouchView = {
        let touchDetectView: IgnoreTouchView = IgnoreTouchView(frame: UIScreen.main.bounds)
        touchDetectView.isUserInteractionEnabled = true
        return touchDetectView
    }()
    
    // MARK: - Properties
    var filterType: FilterType
    // TableView를 외부 View에 추가하기 위해 필요한 UIView 프로퍼티
    private var superView: UIView?
    private var isShowingDropBox: Bool = false
    // 최초로 버튼을 클릭했는지 여부를 확인하기 위한 프로퍼티이다.
    private var isFirstClickButton: Bool = true
    private let tableViewCellHeight: CGFloat = 44
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
        setupBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        self.filterType = .latest
        super.init(coder: coder)
    }
    
    // MARK: - Setup
    
    private func setupBackgroundColor() {
        backgroundColor = SwiftGenColors.primaryBackground.color
        tableView.backgroundColor = SwiftGenColors.primaryBackground.color
        outsideTouchDetectView.backgroundColor = .clear
    }
    
    private func setupView() {
        clipsToBounds = true
        addSubview(titleButton)
        superView?.addSubview(tableView)

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
        tableView.layer.cornerRadius = 5
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        tableView.clipsToBounds = true
        
        superView?.layoutIfNeeded()
        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .top)
        
    }
}

extension DropBoxView {
    private func updateView(title: String) {
        titleButton.setTitle(title, for: .normal)
    }
    
    @objc
    func clickButton() {
        // TableView ( dropBox )를 버튼을 최초로 클릭했을 때 constraint를 지정한다.
        if isFirstClickButton {
            setupTableView()
            isFirstClickButton = false
        }
        
        changeButtonImageView()
    }
    
    /// titleButton의 이미지를 변경하는 메서드다.  변경한다면 DropBox ( tableView ) 가 나오거나 사라져야 한다.
    private func changeButtonImageView() {
        self.outsideTouchDetectView.removeFromSuperview()
        UIView.animate(withDuration: 0.1) {
            self.titleButton.imageView?.transform = self.isShowingDropBox ? .identity : CGAffineTransform(rotationAngle: .pi)
            self.isShowingDropBox.toggle()
        } completion: { _  in
            self.showTableView(self.isShowingDropBox)
        }
    }
    
    private func showTableView(_ bool: Bool) {
        // outsideTouchDetectView를 superView의 최상단에 부착한 후에, tableView를 superView의 가장 최상단으로 옮긴다.
        addOutsideTouchDetectView(bool)
        superView?.bringSubviewToFront(tableView)
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.tableViewHeightConstant?.constant = bool ? self.maxTableViewHeight : 0
            self.superView?.layoutIfNeeded()
        }
    }
    
    /// DropBoxView가 열려있는 상태에서 다른 뷰를 터치할 경우에 DropBoxView를 닫히도록 하기 위하여 outsideTouchDetectView를 추가하는 메서드다.
    /// - Parameter bool: 추가하는 경우에 true를 넣는다.
    private func addOutsideTouchDetectView(_ bool: Bool) {
        if bool == false { return }
        superView?.addSubview(outsideTouchDetectView)
        outsideTouchDetectView.executeClosure = { [weak self] in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.15) {
                DispatchQueue.main.async {
                    if self?.outsideTouchDetectView.superview != nil {
                        self?.changeButtonImageView()
                        self?.outsideTouchDetectView.removeFromSuperview()
                    }
                }
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
        cell.backgroundColor = SwiftGenColors.primaryBackground.color
        cell.textLabel?.text = filterType.list[indexPath.row]
        cell.textLabel?.font = selectedIndexPath == indexPath ? UIFont.Pretendard.title3 : UIFont.Pretendard.body3
        cell.textLabel?.textColor = selectedIndexPath == indexPath ? SwiftGenColors.primaryBlack.color : SwiftGenColors.gray2.color
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
            cell.textLabel?.textColor = SwiftGenColors.gray2.color
        }
        selectedIndexPath = indexPath
        
        // 현재 선택된 cell을 강조한다.
        if let cell: UITableViewCell = tableView.cellForRow(at: selectedIndexPath) {
            cell.textLabel?.font = UIFont.Pretendard.title3
            cell.textLabel?.textColor = SwiftGenColors.primaryBlack.color
        }
        let title: String = filterType.list[indexPath.row]
        updateView(title: title)
        selectFilterTypeSubject.onNext((filterType, title))
        
        // cell을 선택한다면 dropBox( tableView )는 사라져야 한다.
        layoutIfNeeded()
        changeButtonImageView()
    }
}
