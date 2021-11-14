//
//  SplashCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/09.
//

import UIKit

final class SplashCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController = UINavigationController()
    
    weak var window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let splash: SplashViewController = SplashViewController()
        splash.coordinator = self
        window?.rootViewController = splash
        window?.makeKeyAndVisible()
    }
    
    func next() {
        OnboardingCoordinator(window).start()
    }
}
