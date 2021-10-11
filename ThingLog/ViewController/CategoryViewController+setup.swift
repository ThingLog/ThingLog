//
//  CategoryViewController+setup.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/02.
//

import UIKit

extension CategoryViewController {
    // MARK: - Setup
    func setupCategoryView() {
        view.addSubview(categoryView)
        let safeLayoutGuide: UILayoutGuide = view.safeAreaLayoutGuide
        categoryViewHeightConstriant = categoryView.heightAnchor.constraint(equalToConstant: categoryView.normalHeight)
        self.currentCategoryHeight = categoryView.normalHeight
        categoryViewHeightConstriant?.isActive = true
        NSLayoutConstraint.activate([
            categoryView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            categoryView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor)
        ])
    }
    
    func setupTopButton() {
        view.addSubview(topButton)
        let safeLayoutGuide: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            topButton.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -26),
            topButton.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -29),
            topButton.widthAnchor.constraint(equalToConstant: 44),
            topButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        topButton.layer.cornerRadius = 22
        topButton.clipsToBounds = true
    }
    
    /// 하단에 스크롤 가능한 컬렉션뷰를 나타내는 컨트롤러가 위치할 ContainerView를 셋업한다.
    func setupContainerView() {
        view.addSubview(contentsContainerView)
        NSLayoutConstraint.activate([
            contentsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentsContainerView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            contentsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    /// 하단에 스크롤 가능한 컬렉션뷰를 나타내는 BaseViewController를 셋업한다.
    func setupContentsController() {
        addChild(contentsViewController)
        
        contentsContainerView.addSubview(contentsViewController.view)
        let contentsView: UIView = contentsViewController.view
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentsView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            contentsView.topAnchor.constraint(equalTo: contentsContainerView.topAnchor),
            contentsView.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor)
        ])
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
        
        let logoView: LogoView = LogoView("모아보기")
        let logoBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: logoView)
        navigationItem.leftBarButtonItem = logoBarButtonItem
        
        let searchButton: UIButton = UIButton()
        searchButton.setImage(SwiftGenAssets.search.image, for: .normal)
        searchButton.tintColor = SwiftGenColors.black.color
        searchButton.rx.tap.bind { [weak self] in
            self?.coordinator?.showSearchViewController()
        }
        .disposed(by: disposeBag)
        
        let settingButton: UIButton = UIButton()
        settingButton.setImage(SwiftGenAssets.setting.image, for: .normal)
        settingButton.tintColor = SwiftGenColors.black.color
        settingButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.showSettingViewController()
            }
            .disposed(by: disposeBag)
        
        let settingBarButton: UIBarButtonItem = UIBarButtonItem(customView: settingButton)
        let searchBarButton: UIBarButtonItem = UIBarButtonItem(customView: searchButton)
        let spacingBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacingBarButton.width = 24
        navigationItem.rightBarButtonItems = [settingBarButton, spacingBarButton, searchBarButton]
    }
}
