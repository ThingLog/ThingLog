//
//  EasyLookViewController+setup.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/02.
//

import UIKit

extension EasyLookViewController {
    // MARK: - Setup
    
    func setupBackgroundColor() {
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        topButton.backgroundColor = SwiftGenColors.primaryBackground.color
    }
    func setupEasyLookTopView() {
        view.addSubview(easyLookTopView)
        let safeLayoutGuide: UILayoutGuide = view.safeAreaLayoutGuide
        easyLookTopViewHeightConstriant = easyLookTopView.heightAnchor.constraint(equalToConstant: easyLookTopView.normalHeight)
        self.currentEasyLookTopViewHeight = easyLookTopView.normalHeight
        easyLookTopViewHeightConstriant?.isActive = true
        NSLayoutConstraint.activate([
            easyLookTopView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            easyLookTopView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            easyLookTopView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor)
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
            contentsContainerView.topAnchor.constraint(equalTo: easyLookTopView.bottomAnchor),
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
        setupBaseNavigationBar()
        
        let logoView: LogoView = LogoView("모아보기")
        let logoBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: logoView)
        navigationItem.leftBarButtonItem = logoBarButtonItem
        
        let searchButton: UIButton = UIButton()
        searchButton.setImage(SwiftGenIcons.search.image, for: .normal)
        searchButton.tintColor = SwiftGenColors.primaryBlack.color
        searchButton.rx.tap.bind { [weak self] in
            self?.coordinator?.showSearchViewController()
        }
        .disposed(by: disposeBag)
        
        let settingButton: UIButton = UIButton()
        settingButton.setImage(SwiftGenIcons.system.image, for: .normal)
        settingButton.tintColor = SwiftGenColors.primaryBlack.color
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
