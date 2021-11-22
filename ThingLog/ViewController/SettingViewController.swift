//
//  SettingViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/10.
//
import RxSwift
import UIKit

/// 설정화면을 보여주는 ViewController다.
final class SettingViewController: UIViewController {
    var coordinator: SettingCoordinator?
    
    /// 설정화면의 tableView cell에 들어가는 값을 추상화한 enum 타입이다.
    private enum TableViewCellType: Int, CaseIterable {
        case darkMode
        case editCategory
        case trash
        case addDummyData
        case deleteDummyData
        case resetUserInfor
        case clearDrawer
        case blackCard
        case dragonball
        case basket
        case rightAward
        case comment

        var title: String {
            switch self {
            case .darkMode:
                return "다크모드"
            case .editCategory:
                return "카테고리 수정"
            case .trash:
                return "휴지통"
            case .addDummyData:
                return "랜덤 데이터 400개 추가"
            case .deleteDummyData:
                return "랜덤 데이터 모두 삭제"
            case .resetUserInfor:
                return "유저정보 초기화 ( 앱 종료됩니다 )"
            case .clearDrawer:
                return "진열장 아이템 초기화"
            case .blackCard:
                return "진열장 - 블랙카드 획득"
            case .dragonball:
                return "진열장 - 드래곤볼 획득"
            case .basket:
                return "진열장 - 장바구니 획득"
            case .rightAward:
                return "진열장 - 인의예지상 획득"
            case .comment:
                return "댓글 화면"
            }
        }
    }
    
    private let topBorderLineView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = SwiftGenColors.gray4.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.register(LeftLabelRightButtonTableCell.self, forCellReuseIdentifier: LeftLabelRightButtonTableCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        return tableView
    }()
    
    // MARK: - Properties
    
    private let userInformationViewModel: UserInformationViewModelable = UserInformationiCloudViewModel()
    private var userInformation: UserInformationable?
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkMode()
        setupTableView()
        setupNavigationBar()
        setupBackgroundColor()
        
        fetchUserInformation()
    }
    
    // MARK: - Setup
    
    func setupBackgroundColor() {
        tableView.backgroundColor = SwiftGenColors.primaryBackground.color
        view.backgroundColor = SwiftGenColors.primaryBackground.color
    }

    func setupTableView() {
        view.addSubview(tableView)
        view.addSubview(topBorderLineView)
        
        NSLayoutConstraint.activate([
            topBorderLineView.heightAnchor.constraint(equalToConstant: 0.5),
            topBorderLineView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBorderLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBorderLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: topBorderLineView.bottomAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupNavigationBar() {
        setupBaseNavigationBar()
        
        let logoView: LogoView = LogoView("설정", font: UIFont.Pretendard.headline4)
        navigationItem.titleView = logoView
        
        let backButton: UIButton = UIButton()
        backButton.setImage(SwiftGenIcons.longArrowR.image.withRenderingMode(.alwaysTemplate), for: .normal)
        backButton.tintColor = SwiftGenColors.primaryBlack.color
        backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.back()
            }
            .disposed(by: disposeBag)
        let backBarButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    func fetchUserInformation() {
        userInformationViewModel.fetchUserInformation { userInformation in
            self.userInformation = userInformation
            self.tableView.reloadData()
        }
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TableViewCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: LeftLabelRightButtonTableCell = tableView.dequeueReusableCell(withIdentifier: LeftLabelRightButtonTableCell.reuseIdentifier, for: indexPath) as? LeftLabelRightButtonTableCell else {
            return UITableViewCell()
        }
        
        if let cellType: TableViewCellType = TableViewCellType(rawValue: indexPath.row) {
            cell.updateLeftLabelTitle(cellType.title)
            
            switch cellType {
            case .darkMode:
                cell.changeViewType(labelType: .withBody1,
                                    buttonType: .withToggleButton,
                                    borderLineHeight: .with05Height,
                                    borderLineColor: .withGray4)
                cell.rightToggleButton.setOn(userInformation?.isAumatedDarkMode ?? true, animated: false)
                cell.rightToggleButton.rx.isOn
                    .bind { [weak self] bool in
                        self?.userInformation?.isAumatedDarkMode = bool
                        guard let userInformation = self?.userInformation else {
                            return
                        }
                        self?.userInformationViewModel.updateUserInformation(userInformation)
                        self?.setDarkMode()
                    }
                    .disposed(by: cell.disposeBag)
            case .editCategory, .trash, .addDummyData, .deleteDummyData, .resetUserInfor, .clearDrawer, .blackCard, .basket, .rightAward, .dragonball, .comment:
                cell.changeViewType(labelType: .withBody1,
                                    buttonType: .withChevronRight,
                                    borderLineHeight: .with05Height,
                                    borderLineColor: .withGray4)
            }
        }
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellType: TableViewCellType = TableViewCellType(rawValue: indexPath.row) {
            let drawerRepo = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared,
                                                      defaultDrawers: DefaultDrawerModel().drawers)
            
            switch cellType {
            case .darkMode:
                return
            case .editCategory:
                coordinator?.showCategoryViewController()
            case .trash:
                coordinator?.showTrashViewController()
            case .addDummyData:
                makeDummy()
            case .deleteDummyData:
                deleteAllEntity()
            case .resetUserInfor:
                UserInformationiCloudViewModel().resetUserInformation()
                exit(1)
            case .clearDrawer:
                drawerRepo.deleteAllDrawers()
                coordinator?.navigationController.viewControllers.forEach {
                    guard let homeViewController = $0 as? HomeViewController else { return }
                    homeViewController.fetchRepresentativeDrawer()
                    
                }
            case .blackCard:
                drawerRepo.updateVIP(by: 1_000_000)
            case .dragonball:
                drawerRepo.updateDragonBall(rating: 1)
                drawerRepo.updateDragonBall(rating: 2)
                drawerRepo.updateDragonBall(rating: 3)
                drawerRepo.updateDragonBall(rating: 4)
                drawerRepo.updateDragonBall(rating: 5)
            case .basket:
                drawerRepo.updateBasket()
            case .rightAward:
                drawerRepo.updateRightAward()
            case .comment:
                coordinator?.showCommentViewController()
            }
        }
    }
}

