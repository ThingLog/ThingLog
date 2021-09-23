//
//  HomeViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//
import UIKit

final class HomeViewController: UIViewController {
    let profileView: ProfileView = {
        let profileView: ProfileView = ProfileView()
        profileView.backgroundColor = .white
        profileView.translatesAutoresizingMaskIntoConstraints = false
        return profileView
    }()
    
    var coordinator: Coordinator?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        setupNavigationBar()
    }
    
    func setupView() {
        view.backgroundColor = .gray
        view.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 54 + 17)
        ])
    }
    
    func setupNavigationBar() {
        if #available(iOS 15, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = .clear
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }
        
        let logoView: UILabel = UILabel()
        logoView.text = "띵로그"
        logoView.textColor = .black
        logoView.font = UIFont.boldSystemFont(ofSize: 20.0)
        let logoBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: logoView)
        navigationItem.leftBarButtonItem = logoBarButtonItem
        
        let settingButton: UIButton = UIButton()
        settingButton.setImage(UIImage(named: "setting"), for: .normal)
        settingButton.tintColor = .black
        // settingButton.addTarget(self, action: #selector(showSettingView), for: .touchUpInside)
        let settingBarButton: UIBarButtonItem = UIBarButtonItem(customView: settingButton)
        navigationItem.rightBarButtonItem = settingBarButton
    }
}
