//
//  SearchViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/02.
//
import CoreData
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
    
    // 검색결과가 없는 경우에 보여주는 뷰다
    private let emptyView: EmptyResultsView = {
        let view: EmptyResultsView = EmptyResultsView()
        view.isHidden = true
        view.backgroundColor = SwiftGenColors.white.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchResultsViewController: SearchResultsViewController = SearchResultsViewController()
    
    // MARK: - Properties
    private let recentSearchDataViewModel: RecentSearchDataViewModel = RecentSearchDataViewModel()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color
        setupNavigationBar()
        setupContainerView()
        setupRecentSearchView()
        setupSearchResultsViewContorller()
        setupEmptyView()
        
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
            containerView.topAnchor.constraint(equalTo: safeLayout.topAnchor)
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
    
    func setupEmptyView() {
        view.addSubview(emptyView)
        let safeLayout: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            emptyView.topAnchor.constraint(equalTo: safeLayout.topAnchor)
        ])
    }
    
    // MARK: - Subscribe
    /// CustomTextField에 BackButton을 subscribe 한다.
    private func subscribeBackButton() {
        searchTextField.backButton.rx.tap.bind { [weak self] in
            self?.coordinator?.back()
        }
        .disposed(by: disposeBag)
    }
    
    /// 최근검색어의 테이블뷰 셀을 선택했을 때 subscribe합니다.
    private func subscribeTableViewSelectIndex() {
        recentSearchView.selectedIndexPathSubject
            .bind { [weak self] keyword in
                self?.hideKeyboard()
                self?.searchTextField.changeTextField(by: keyword)
                self?.showSearchResultsViewController(true, keyWord: keyword)
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
    private func showSearchResultsViewController(_ bool: Bool, keyWord: String? = nil ) {
        if bool {
            fetchAllPost(by: keyWord)
        } else {
            self.searchResultsViewController.view.isHidden = true
            self.emptyView.isHidden = true
        }
    }
    
    /// 검색한 키워드로 조건에 맞는 Post들을 모두 찾는다.
    /// - Parameter keyWord: 검색하고자 하는 키워드를 넣는다.
    private func fetchAllPost(by keyWord: String? = nil ) {
        guard let keyWord: String = keyWord else {
            return
        }
        searchResultsViewController.viewModel.fetchAllRequest(keyWord: keyWord) { searchedCount in
            if searchedCount != 0 {
                self.searchResultsViewController.viewModel.fetchedResultsControllers.forEach {
                    $0.delegate = self
                }
                self.searchResultsViewController.collectionView.reloadData()
                self.searchResultsViewController.totalFilterView.updateResultTotalLabel(by: "검색결과 \(searchedCount)건")
            }
            self.searchResultsViewController.view.isHidden = searchedCount == 0
            self.searchResultsViewController.isAllContentsShowing = false
            self.emptyView.isHidden = searchedCount != 0
            self.emptyView.updateTitle(keyWord)
        }
    }
    
    private func hideKeyboard() {
        searchTextField.endEditing(true)
    }
}

extension SearchViewController: SearchTextFieldDelegate {
    func searchTextFieldDidChangeSelection(_ textField: UITextField) {
        guard let text: String = checkTextField(textField.text) else {
            showSearchResultsViewController(false)
            return
        }
        showSearchResultsViewController(true, keyWord: text)
    }
    
    func searchTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text: String = checkTextField(textField.text) {
            if recentSearchDataViewModel.isAutoSaveMode {
                recentSearchDataViewModel.add(textField.text!)
            }
            showSearchResultsViewController(true, keyWord: text)
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

// SearchViewController에서 하는 이유는, SearchResultsViewController에서 하게되면 총 검색결과 갯수들을 싱크하는데 있어서 어려움이 있고, 이를 실시간으로 반영하기 보다는 검색홈으로 가도록 하는 로직을 구성했다. 검색홈으로 가는 로직을 위해서는 SearchViewController에서 delegate를 구현하는게 훨씬 간단하다.
extension SearchViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        showSearchResultsViewController(false)
    }
}
