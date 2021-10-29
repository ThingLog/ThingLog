//
//  DrawerCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/28.
//

import UIKit

final class DrawerCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let drawerViewController: DrawerViewController = DrawerViewController()
        drawerViewController.coordinator = self
        drawerViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(drawerViewController, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    /// 진열장의 특정 아이템을 대표설정 할 수 있는 뷰컨트롤러를 호출한다.
    func showSelectingDrawerViewController() {
        let selectingDrawerViewController: SelectingDrawerViewController = SelectingDrawerViewController()
        selectingDrawerViewController.coordinator = self
        selectingDrawerViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(selectingDrawerViewController, animated: false)
    }
    
    ///  대표설정 진열장 뷰컨트롤러를 dismiss한다.
    func detachSelectingDrawerViewController() {
        guard let selecting: SelectingDrawerViewController = navigationController.presentedViewController as? SelectingDrawerViewController else { return }
        selecting.dismiss(animated: false, completion: nil)
    }
}
