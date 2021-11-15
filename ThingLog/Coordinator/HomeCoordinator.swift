//
//  HomeCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/18.
//

import UIKit

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController: HomeViewController = HomeViewController()
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: true)
    }
    
    /// 설정화면으로 이동하기 위한 메서드다
    func showSettingViewController() {
        let settingCoordinator: SettingCoordinator = SettingCoordinator(navigationController: navigationController)
        settingCoordinator.start()
    }
    
    func showLoginViewController() {
        let loginViewController: LoginViewController = LoginViewController(isLogin: false)
        loginViewController.coordinator = self
        loginViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func showDrawerViewController() {
        let drawerCoordinator: DrawerCoordinator = DrawerCoordinator(navigationController: navigationController)
        drawerCoordinator.start()
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}

extension HomeCoordinator: PostCoordinatorProtocol {
    func showPostViewController(with viewModel: PostViewModel) {
        // TODO: - ⚠️ PostViewController로 대체할 예정
        navigationController.pushViewController(TestPostViewController(postViewModel: viewModel), animated: true)
    }
}
