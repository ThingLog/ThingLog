//
//  OnboardingCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/14.
//

import UIKit

/// 온보딩 화면을 돕는 Coordinator이고, 유저정보가 있다면 온보딩을 스킵하고, TabBar를 보여준다.
class OnboardingCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController = UINavigationController()
    
    weak var window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        // 이미 유저정보가 있는 경우에는 온보딩을 스킵하고, TabBar를 보여준다. 
        UserInformationiCloudViewModel().fetchUserInformation { userInformation in
            if let _ = userInformation {
                self.window?.rootViewController = TabBarController()
            } else {
                let onboarding: OnboardingStartViewController = OnboardingStartViewController()
                onboarding.coordinator = self
                self.navigationController.pushViewController(onboarding, animated: false)
                self.window?.rootViewController = self.navigationController
            }
        }
        window?.makeKeyAndVisible()
    }
    
    func showOnboardingList() {
        let onboardingList: OnboardingListViewController = OnboardingListViewController()
        onboardingList.coordinator = self
        // 메모리 해제
        if let startViewController: OnboardingStartViewController = navigationController.topViewController as? OnboardingStartViewController {
            startViewController.coordinator = nil
        }
        navigationController.pushViewController(onboardingList, animated: true)
    }
    
    func showLoginViewController() {
        // 메모리 해제
        if let onboardingList: OnboardingListViewController = navigationController.topViewController as? OnboardingListViewController {
            onboardingList.coordinator = nil
        }
        LoginCoordinator(window: window, navigationController: UINavigationController()).start()
    }
}
