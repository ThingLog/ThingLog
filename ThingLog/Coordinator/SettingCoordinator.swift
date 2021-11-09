//
//  SettingCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/10.
//

import UIKit

/// 설정화면에서 뷰전환을 돕는 Coordinator이다.
final class SettingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let settingViewController: SettingViewController = SettingViewController()
        settingViewController.coordinator = self
        settingViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(settingViewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    func showTrashViewController() {
        let trashViewController: TrashViewController = TrashViewController()
        trashViewController.coordinator = self
        trashViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(trashViewController, animated: true)
    }
    
    func showLoginViewController() {
        let loginViewController: LoginViewController = LoginViewController(isLogin: true)
        loginViewController.coordinator = self
        loginViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(loginViewController, animated: true)
    }

    func showPostViewController() {
        let postViewController: PostViewController = PostViewController()
        postViewController.coordinator = self
        postViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(postViewController, animated: true)
    }
}
