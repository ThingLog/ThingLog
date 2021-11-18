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
        case card
        case login
        case addDummyData
        case deleteDummyData
        case alert1
        case alert2
        case alert3
        case resetUserInfor
        case post
        case clearDrawer
        case blackCard
        case dragonball
        case basket
        case rightAward
        
        var title: String {
            switch self {
            case .darkMode:
                return "다크모드"
            case .editCategory:
                return "카테고리 수정"
            case .card:
                return "포토카드"
            case .trash:
                return "휴지통"
            case .login:
                return "로그인 화면 ( 테스트 )"
            case .addDummyData:
                return "랜덤 데이터 400개 추가"
            case .deleteDummyData:
                return "랜덤 데이터 모두 삭제"
            case .alert1:
                return "기본 Alert"
            case .alert2:
                return "내용과 버튼 하나만 있는 Alert"
            case .alert3:
                return "제목과 텍스트필드, 두개의 버튼 있는 Alert"
            case .resetUserInfor:
                return "유저정보 초기화 ( 앱 종료됩니다 )"
            case .post:
                return "게시물 화면"
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
                    }
                    .disposed(by: cell.disposeBag)
                
            case .editCategory, .trash, .card, .login, .addDummyData, .deleteDummyData, .alert1, .alert2, .alert3, .resetUserInfor, .post, .clearDrawer, .blackCard, .basket, .rightAward, .dragonball:
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
                return
            case .trash:
                coordinator?.showTrashViewController()
            case .card:
                let card = PhotoCardViewController(postEntity: PostEntity(),
                                                   selectImage: SwiftGenIcons.group.image)
                card.coordinator = coordinator
                navigationController?.pushViewController(card, animated: true)
            case .login:
                coordinator?.showLoginViewController()
            case .addDummyData:
                makeDummy()
            case .deleteDummyData:
                deleteAllEntity()
            case .alert1:
                showAlert1()
            case .alert2:
                showAlert2()
            case .alert3:
                showAlert3()
            case .resetUserInfor:
                UserInformationiCloudViewModel().resetUserInformation()
                exit(1)
            case .post:
                coordinator?.showPostViewController()
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
            }
        }
    }
    func showAlert1() {
        let alert = AlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false, completion: nil)
        }
        present(alert, animated: false, completion: nil)
    }
    
    func showAlert2() {
        let alert = AlertViewController()
        alert.modalPresentationStyle = .overFullScreen
        alert.hideTitleLabel()
        alert.hideRightButton()
        alert.hideTextField()
        alert.changeContentsText("이미지는 최대 10개까지 첨부할 수 있어요")
        alert.leftButton.setTitle("확인", for: .normal)
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false, completion: nil)
        }
        present(alert, animated: false, completion: nil)
    }
    
    func showAlert3() {
        let alert = AlertViewController()
        alert.hideContentsLabel()
        alert.titleLabel.text = "카테고리 수정"
        alert.leftButton.setTitle("취소", for: .normal)
        alert.rightButton.setTitle("확인", for: .normal)
        alert.modalPresentationStyle = .overFullScreen
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false, completion: nil)
        }
        present(alert, animated: false, completion: nil)
    }
}

