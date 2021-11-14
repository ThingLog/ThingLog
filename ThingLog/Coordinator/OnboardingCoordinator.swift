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
        let onboarding: OnboardingStartViewController = OnboardingStartViewController()
        onboarding.coordinator = self
        navigationController.pushViewController(onboarding, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
