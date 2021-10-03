//
//  RecentSearchView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/03.
//

import UIKit
/*
 headerStackView: UIStackView - horizontal  {
    [ emptyLeadingView,
      recentTitleLabel,
      clearTotalButton,
      emptyTrailingView]
 }
 
 informationStackView: UIStackView - vertical  {
    [ informationLabel,
      informationBorderLineView ]
 }
 
 autoSaveContenstStackView: UIStackView - Horizontal {
    [ autoSaveLeadingEmptyView,
      autoSaveButton,
      autoSaveTrailingEmptyView ]
 }
 
 autoSaveStackView: UIStackView - vertical {
    [ autoSaveTopEmptyView,
      autoSaveContenstStackView ]
 }
 
 stackView: UIStackView - vertical {
    [ headerStackView,
      informationStackView,
      tableView,
      autoSaveStackView]
 }
 
 */
/// 최근검색어와 그에 따른 필요한 뷰들을 구성하는 View다.
final class RecentSearchView: UIView {
    // MARK: - VIew
    private let emptyLeadingView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var recentTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title2
        label.text = "최근 검색"
        label.textColor = SwiftGenColors.black.color
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var clearTotalButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.setTitleColor(SwiftGenColors.gray3.color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let emptyTrailingView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var informationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "최근 검색어 내역이 없습니다"
        label.font = UIFont.Pretendard.body1
        label.textColor = SwiftGenColors.black.color
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var informationBorderLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.gray4.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var autoSaveButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("자동저장 끄기", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.title3
        button.setTitleColor(SwiftGenColors.gray3.color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var autoSaveLeadingEmptyView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var autoSaveTopEmptyView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var autoSaveTrailingEmptyView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private lazy var autoSaveContenstStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            autoSaveLeadingEmptyView,
            autoSaveButton,
            autoSaveTrailingEmptyView
        ])
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            emptyLeadingView,
            recentTitleLabel,
            clearTotalButton,
            emptyTrailingView
        ])
        stackView.axis = .horizontal
        return stackView
    }()
    
    lazy var informationStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            informationLabel,
            informationBorderLineView
        ])
        stackView.axis = .vertical
        return stackView
    }()
    
    var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = SwiftGenColors.white.color
        tableView.register(LeftLabelRightButtonTableCell.self, forCellReuseIdentifier: LeftLabelRightButtonTableCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setContentHuggingPriority(.required, for: .vertical)
        return tableView
    }()
    
    private lazy var autoSaveStackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            autoSaveTopEmptyView,
            autoSaveContenstStackView
        ])
        stackView.axis = .vertical
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            headerStackView,
            informationStackView,
            tableView,
            autoSaveStackView
        ])
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    private let emptyViewWidth: CGFloat = 18
    private let autoSaveEmptyViewWidth: CGFloat = 30
    private let informationLabelHeight: CGFloat = 147
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private let autoSaveStackViewHeight: CGFloat = 40
    
    var isAutoSaveMode: Bool = true {
        didSet {
            autoSaveButton.setTitle(isAutoSaveMode ? "자동저장 끄기" : "자동저장 켜기", for: .normal)
        }
    }
    
    // TODO: ⚠️ RecentSearchDataModel로 변경예정
    var testData: [String] = (0..<5).map { _ in  String("활성화") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        // stackView안에서 tableView의 높이를 동적으로 관리하기 위함이다.
        tableViewHeightConstraint?.constant = tableView.contentSize.height
    }
    override func layoutIfNeeded() {
        tableViewHeightConstraint?.constant = tableView.contentSize.height
    }
    
    private func setupView() {
        addSubview(stackView)
        backgroundColor = SwiftGenColors.white.color
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(lessThanOrEqualToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            
            emptyLeadingView.widthAnchor.constraint(equalToConstant: emptyViewWidth),
            emptyTrailingView.widthAnchor.constraint(equalToConstant: emptyViewWidth),
            
            autoSaveLeadingEmptyView.widthAnchor.constraint(equalToConstant: autoSaveEmptyViewWidth),
            informationStackView.heightAnchor.constraint(equalToConstant: informationLabelHeight),
            informationBorderLineView.heightAnchor.constraint(equalToConstant: 0.5),
            autoSaveTopEmptyView.heightAnchor.constraint(equalToConstant: 5),
            autoSaveStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: autoSaveStackViewHeight)
        ])
        
        tableView.dataSource = self
        informationStackView.isHidden = true
    }
    
    /// 최근 검색어 내역이 없거나, 검색어 저장 기능이 꺼져있는 경우를 표시하기 위해 업데이트하는 메서드다
    func updateInformationLabel() {
        if isAutoSaveMode {
            informationStackView.isHidden = !testData.isEmpty
            tableView.isHidden = testData.isEmpty
            informationLabel.text = "최근 검색어 내역이 없습니다"
        } else {
            informationStackView.isHidden = false
            informationLabel.text = "검색어 저장 기능이 꺼져 있습니다"
            tableView.isHidden = true
        }
    }
}

extension RecentSearchView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        testData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LeftLabelRightButtonTableCell.reuseIdentifier, for: indexPath) as? LeftLabelRightButtonTableCell else { return UITableViewCell() }
        cell.updateLeftLabelTitle(testData[indexPath.row])
        return cell
    }
}
