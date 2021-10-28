//
//  RootCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/27.
//

import UIKit

/// 가장 처음에 시작하는 Coordinator로, 로그인화면 또는 바로 홈화면을 보여주도록 하는 객체다.
final class RootCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var window: UIWindow?
    
    init(window: UIWindow?,
         navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.window = window
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    // 가장 처음에 시작하는 화면을 결정하는 메소드다.
    func start() {
        if UserInformationViewModel.shared.userAliasName == nil {
            let loginViewController: LoginViewController = LoginViewController(isLogin: true)
            loginViewController.coordinator = self
            navigationController.pushViewController(loginViewController, animated: true)
        } else {
            showTabBarController()
        }
    }
    
    // 현재 화면이 LoginViewController인 경우에 홈화면으로 보여주기 위한 메소드다.
    func showTabBarController() {
        if let login: LoginViewController = navigationController.topViewController as? LoginViewController {
            // RootCoordinator, LoginViewContorller 메모리 해제
            login.coordinator = nil
        }
        self.window?.rootViewController = TabBarController()
    }
}
