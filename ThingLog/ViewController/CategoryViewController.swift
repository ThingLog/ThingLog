//
//  CategoryViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/20.
//

import UIKit

final class CategoryViewController: UIViewController {
    var coordinator: Coordinator?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color
        setupNavigationBar()
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
        
        let settingButton: UIButton = UIButton()
        settingButton.setImage(SwiftGenAssets.setting.image, for: .normal)
        settingButton.tintColor = SwiftGenColors.black.color
        // settingButton.addTarget(self, action: #selector(showSettingView), for: .touchUpInside)
        let settingBarButton: UIBarButtonItem = UIBarButtonItem(customView: settingButton)
        let searchBarButton: UIBarButtonItem = UIBarButtonItem(customView: searchButton)
        let spacingBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacingBarButton.width = 24
        navigationItem.rightBarButtonItems = [settingBarButton, spacingBarButton, searchBarButton]
    }
}
