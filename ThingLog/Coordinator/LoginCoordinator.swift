//
//  LoginCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/27.
//

import UIKit

/// 로그인화면을 담당하는 Coordinator다. 
final class LoginCoordinator: Coordinator {
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
    
    // 로그인화면을 보여주도록한다. 
    func start() {
        let loginViewController: LoginViewController = LoginViewController(isLogin: true)
        loginViewController.coordinator = self
        self.navigationController.pushViewController(loginViewController, animated: true)
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
