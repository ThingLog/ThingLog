//
//  RecentSearchView.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/03.
//
import RxSwift
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
 emptyHeightView,
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
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recentTitleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = UIFont.Pretendard.title2
        label.text = "최근 검색"
        label.textColor = SwiftGenColors.black.color
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let clearTotalButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.body2
        button.setTitleColor(SwiftGenColors.gray3.color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return button
    }()
    
    private let emptyTrailingView: UIView = {
        let view: UIView = UIView()
        view.setContentHuggingPriority(.required, for: .horizontal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let informationLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "최근 검색어 내역이 없습니다"
        label.font = UIFont.Pretendard.body1
        label.textColor = SwiftGenColors.black.color
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let informationBorderLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.gray4.color
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let autoSaveButton: UIButton = {
        let button: UIButton = UIButton()
        button.setTitle("자동저장 끄기", for: .normal)
        button.titleLabel?.font = UIFont.Pretendard.title3
        button.setTitleColor(SwiftGenColors.gray3.color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let autoSaveLeadingEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let autoSaveTopEmptyView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let autoSaveTrailingEmptyView: UIView = {
        let view: UIView = UIView()
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
    
    let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false 
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
    
    private let emptyHeightView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView(arrangedSubviews: [
            headerStackView,
            emptyHeightView,
            informationStackView,
            tableView,
            autoSaveStackView
        ])
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    var recentSearchDataViewModel: RecentSearchDataViewModelProtocol
    
    private let emptyViewWidth: CGFloat = 18
    private let autoSaveEmptyViewWidth: CGFloat = 30
    private let informationLabelHeight: CGFloat = 147
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private let autoSaveStackViewHeight: CGFloat = 40
    private let headerStackViewHeight: CGFloat = 44
    private let emptyHeightViewHeight: CGFloat = 11
    
    var selectedIndexPathSubject: PublishSubject<String> = PublishSubject() 
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Init
    
    /// 초기화하는 메서드며, 최근검색 데이터 모델을 주입한다.
    /// - Parameter recentSearchDataViewModel: 필요한 최근검색 데이터 모델을 주입한다.
    init(recentSearchDataViewModel: RecentSearchDataViewModelProtocol) {
        self.recentSearchDataViewModel = recentSearchDataViewModel
        super.init(frame: .zero)
        setupView()
        setupTableView()
        
        subscribeViewModel()
        subscribeClearButton()
        subscribeAutoSaveButton()
    }
    
    required init?(coder: NSCoder) {
        self.recentSearchDataViewModel = RecentSearchDataViewModel()
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        // stackView안에서 tableView의 높이를 동적으로 관리하기 위함이다.
        tableViewHeightConstraint?.constant = tableView.contentSize.height
        layoutIfNeeded()
        tableView.isScrollEnabled = floor(tableView.bounds.height) < floor(tableView.contentSize.height)
    }
    
    private func setupView() {
        addSubview(stackView)
        backgroundColor = SwiftGenColors.white.color
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(lessThanOrEqualToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        tableViewHeightConstraint?.priority = .defaultLow
        
        let autoSaveStackViewConstraint: NSLayoutConstraint = autoSaveStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: autoSaveStackViewHeight)
        autoSaveStackViewConstraint.priority = .defaultHigh
        autoSaveStackViewConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            
            emptyLeadingView.widthAnchor.constraint(equalToConstant: emptyViewWidth),
            emptyTrailingView.widthAnchor.constraint(equalToConstant: emptyViewWidth),
            
            emptyHeightView.heightAnchor.constraint(equalToConstant: emptyHeightViewHeight),
            headerStackView.heightAnchor.constraint(equalToConstant: headerStackViewHeight),
            autoSaveLeadingEmptyView.widthAnchor.constraint(equalToConstant: autoSaveEmptyViewWidth),
            informationStackView.heightAnchor.constraint(equalToConstant: informationLabelHeight),
            informationBorderLineView.heightAnchor.constraint(equalToConstant: 0.5),
            autoSaveTopEmptyView.heightAnchor.constraint(equalToConstant: 5)
        ])
        informationStackView.isHidden = true
    }
}
