//
//  SearchViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/02.
//

import RxSwift
import UIKit

/// 검색화면을 보여주는 ViewController다.
final class SearchViewController: UIViewController {
    var coordinator: CategoryCoordinator?
    
    private let searchTextField: SearchTextField = {
        let customTextField: SearchTextField = SearchTextField(isOnNavigationbar: true)
        customTextField.translatesAutoresizingMaskIntoConstraints = false
        return customTextField
    }()
    
    private lazy var recentSearchView: RecentSearchView = {
        let tableView: RecentSearchView = RecentSearchView(recentSearchDataViewModel: recentSearchDataViewModel)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let containerView: UIView = {
        let containerView: UIView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    // MARK: - Properties
    private let recentSearchDataViewModel: RecentSearchDataViewModel = RecentSearchDataViewModel()
    
    // 검색결과 에따른 물건리스트가 나오고 있는지 판별하기 위한 프로퍼티
    private var isShowingResults: Bool = false
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color
        setupNavigationBar()
        setupContainerView()
        setupRecentSearchView()
        
        subscribeBackButton()
        subscribeTableViewSelectIndex()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentSearchView.layoutSubviews()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        searchTextField.endEditing(true)
    }
    
    // MARK: - Setup
    private func setupContainerView() {
        let safeLayout: UILayoutGuide = view.safeAreaLayoutGuide
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: 6)
        ])
    }
    
    private func setupRecentSearchView() {
        containerView.addSubview(recentSearchView)

        NSLayoutConstraint.activate([
            recentSearchView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            recentSearchView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            recentSearchView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            recentSearchView.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
    
    private func setupNavigationBar() {
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
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.titleView = searchTextField
        searchTextField.delegate = self
    }
    
    // MARK: - Subscribe
    /// CustomTextField에 BackButton을 subscribe 한다.
    private func subscribeBackButton() {
        searchTextField.backButton.rx.tap.bind { [weak self] in
            if self?.isShowingResults == true {
                // 최근 검색어 리스트로 변경.
                self?.searchTextField.endEditing(true)
                self?.isShowingResults = false
                self?.searchTextField.changeBackButton(isBackMode: true)
            } else {
                // 뒤로 간다 ( 모아보기 화면으로 간다 )
                self?.coordinator?.back()
            }
        }
        .disposed(by: disposeBag)
    }
    
    /// 최근검색어의 테이블뷰 셀을 선택했을 때 subscribe합니다.
    private func subscribeTableViewSelectIndex() {
        recentSearchView.selectedIndexPathSubject
            .bind { [weak self] keyword in
                // TODO: - ⚠️ 검색결과로 이동하기 위한 로직 추가
                print(keyword)
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: SearchTextFieldDelegate {
    func searchTextFieldDidChangeSelection(_ textField: UITextField) {
        isShowingResults = true
        searchTextField.changeBackButton(isBackMode: false)
    }
    
    func searchTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if recentSearchDataViewModel.isAutoSaveMode {
            recentSearchDataViewModel.add(textField.text!)
        }
        return true
    }
}
