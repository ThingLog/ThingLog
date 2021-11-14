//
//  OnboardingCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/14.
//

import UIKit

/// 온보딩 화면을 돕는 Coordinator
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
    
    func showOnboardlingList() {
        let onboardingList: OnboardingListViewController = OnboardingListViewController()
        onboardingList.coordinator = self
        navigationController.pushViewController(onboardingList, animated: true)
    }
    
    func showLoginViewController() {
        // TODO: - ⚠️ memory leak 문제 해결
        RootCoordinator(window: window, navigationController: UINavigationController()).start()
    }
    
    deinit {
        print("onboarding coordinator dead ✅")
    }
}
