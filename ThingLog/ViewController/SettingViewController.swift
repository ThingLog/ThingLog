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
        
        var title: String {
            switch self {
            case .darkMode:
                return "다크모드"
            case .editCategory:
                return "카테고리 수정"
            case .trash:
                return "휴지통"
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
    }
    
    func setupNavigationBar() {
        if #available(iOS 15, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = SwiftGenColors.white.color
            appearance.shadowColor = .clear
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = SwiftGenColors.white.color
            navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }
        
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
            case .editCategory:
                cell.changeViewType(labelType: .withBody1,
                                    buttonType: .withChevronRight,
                                    borderLineHeight: .with1Height,
                                    borderLineColor: .withGray5)
            case .trash:
                cell.changeViewType(labelType: .withBody1,
                                    buttonType: .withChevronRight,
                                    borderLineHeight: .with1Height,
                                    borderLineColor: .withGray5)
            }
        }
        return cell
    }
}