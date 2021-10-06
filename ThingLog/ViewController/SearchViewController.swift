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
    
    private let searchResultsViewController: SearchResultsViewController = SearchResultsViewController()
    
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
        setupSearchResultsViewContorller()
        
        subscribeBackButton()
        subscribeTableViewSelectIndex()
        subscribeRecentView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentSearchView.layoutSubviews()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideKeyboard()
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
    
    private func setupSearchResultsViewContorller() {
        addChild(searchResultsViewController)
        let searchResultsView: UIView = searchResultsViewController.view
        searchResultsView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(searchResultsView)
        
        NSLayoutConstraint.activate([
            searchResultsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            searchResultsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            searchResultsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            searchResultsView.topAnchor.constraint(equalTo: containerView.topAnchor)
        ])
        showSearchResultsViewController(false)
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
                self?.hideKeyboard()
                self?.showSearchResultsViewController(false)
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
                self?.hideKeyboard()
                self?.searchTextField.changeTextField(by: keyword)
                self?.showSearchResultsViewController(true)
            }
            .disposed(by: disposeBag)
    }
    
    /// 자동저장 끄기 버튼 및 전체 삭제 버튼을 subscribe합니다.
    private func subscribeRecentView() {
        recentSearchView.autoSaveButton.rx.tap
            .bind { [weak self] in
                self?.hideKeyboard()
            }
            .disposed(by: disposeBag)
        
        recentSearchView.clearTotalButton.rx.tap
            .bind { [weak self] in
                self?.hideKeyboard()
            }
            .disposed(by: disposeBag)
    }
    
    /// 검색결과화면을 보여주거나 숨기고자 한다.
    /// - Parameter bool: 보여주고자 할때는 true, 그렇지 않다면 false를 넣는다.
    private func showSearchResultsViewController(_ bool: Bool ) {
        searchResultsViewController.view.isHidden = !bool
        isShowingResults = bool
    }
    
    private func hideKeyboard() {
        searchTextField.endEditing(true)
    }
}

extension SearchViewController: SearchTextFieldDelegate {
    func searchTextFieldDidChangeSelection(_ textField: UITextField) {
        guard let text: String = checkTextField(textField.text) else {
            showSearchResultsViewController(false)
            isShowingResults = false
            return
        }
        print(text)
        isShowingResults = true
    }
    
    func searchTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text: String = checkTextField(textField.text) {
            if recentSearchDataViewModel.isAutoSaveMode {
                recentSearchDataViewModel.add(textField.text!)
            }
            // TODO: - ⚠️ 키워드를 통해서 NSFetchRequest + NSFetchResultsController 생성하여 업데이트
            print(text)
            showSearchResultsViewController(true)
        }
        hideKeyboard()
        return true
    }
    
    /// 공백만 포함된 경우를 체크한다.
    /// - Parameter text: String 옵셔널 타입을 주입한다.
    /// - Returns: 공백일 경우는 nil, 그렇지 않은 경우는 String이 된다.
    func checkTextField(_ text: String? ) -> String? {
        guard let text = text,
              !text.isEmpty,
              !text.filter({ $0 != " " }).isEmpty else {
            return nil
        }
        return text
    }
}
