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
}
