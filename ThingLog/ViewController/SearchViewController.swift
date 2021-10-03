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
    
    var recentSearchView: RecentSearchView = {
        let tableView: RecentSearchView = RecentSearchView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // 검색결과 에따른 물건리스트가 나오고 있는지 판별하기 위한 프로퍼티
    private var isShowingResults: Bool = false
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color
        setupNavigationBar()
        
        subscribeBackButton()
        setupTableView()
        bind()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        searchTextField.endEditing(true)
    }
    
    func setupTableView() {
        let safeLayout = view.safeAreaLayoutGuide
        view.addSubview(recentSearchView)
        
        NSLayoutConstraint.activate([
            recentSearchView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            recentSearchView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor),
            recentSearchView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor),
            recentSearchView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: 6)
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
    
    func bind() {
        recentSearchView.autoSaveButton.rx.tap
            .bind { [weak self] in
                self?.recentSearchView.isAutoSaveMode.toggle()
                self?.recentSearchView.updateInformationLabel()
                self?.recentSearchView.layoutSubviews()
            }
            .disposed(by: disposeBag)
        
        recentSearchView.clearTotalButton.rx.tap
            .bind { [weak self] in
                self?.recentSearchView.testData = []
                self?.recentSearchView.informationStackView.isHidden = false
                self?.recentSearchView.layoutSubviews()
                self?.recentSearchView.tableView.reloadData()
                
            }
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: SearchTextFieldDelegate {
    func customTextFieldDidChangeSelection(_ textField: UITextField) {
        isShowingResults = true
        searchTextField.changeBackButton(isBackMode: false)
        print(textField.text)
    }
    
    func customTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text)
        recentSearchView.informationStackView.isHidden = true
        recentSearchView.testData.append(textField.text!)
        recentSearchView.layoutSubviews()
        recentSearchView.tableView.reloadData()
        
//        recentSearchView.layoutSubviews()
//        recentSearchView.layoutSubviews()
        return true
    }
}

