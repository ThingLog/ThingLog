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
    /// 설정화면의 tableView cell에 들어가는 값을 추상화한 enum 타입이다.
    private enum TableViewCellType: Int, CaseIterable {
        case darkMode = 0
        case editCategory = 1
        case trash = 2
        case login = 3
        case addDummyData = 4
        case deleteDummyData = 5
        case alert1 = 6
        case alert2 = 7
        case alert3 = 8
        
        var title: String {
            switch self {
            case .darkMode:
                return "다크모드"
            case .editCategory:
                return "카테고리 수정"
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
            }
        }
    }
    var coordinator: SettingCoordinator?
    
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
        tableView.backgroundColor = SwiftGenColors.white.color
        return tableView
    }()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color
        setupTableView()
        setupNavigationBar()
    }
    
    // MARK: - Setup
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
        backButton.setImage(SwiftGenAssets.paddingBack.image, for: .normal)
        backButton.tintColor = SwiftGenColors.black.color
        backButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.back()
            }
            .disposed(by: disposeBag)
        let backBarButton: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButton
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
                                    borderLineHeight: .with1Height,
                                    borderLineColor: .withGray5)
                cell.rightToggleButton.setOn(UserInformationViewModel.shared.isAutomatedDarkMode, animated: false)
                cell.rightToggleButton.rx.isOn
                    .bind { bool in
                        UserInformationViewModel.shared.isAutomatedDarkMode = bool
                    }
                    .disposed(by: cell.disposeBag)
                
            case .editCategory, .trash, .login, .addDummyData, .deleteDummyData, .alert1, .alert2, .alert3:
                cell.changeViewType(labelType: .withBody1,
                                    buttonType: .withChevronRight,
                                    borderLineHeight: .with1Height,
                                    borderLineColor: .withGray5)
            }
        }
        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellType: TableViewCellType = TableViewCellType(rawValue: indexPath.row) {
            switch cellType {
            case .darkMode:
                return
            case .editCategory:
                return
            case .trash:
                coordinator?.showTrashViewController()
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

