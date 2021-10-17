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
}
