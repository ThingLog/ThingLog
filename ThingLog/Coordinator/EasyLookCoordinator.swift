//
//  EasyLookCoordinator.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/18.
//

import UIKit

final class EasyLookCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let easyLookViewController: EasyLookViewController = EasyLookViewController()
        easyLookViewController.coordinator = self 
        navigationController.pushViewController(easyLookViewController, animated: true)
    }
    
    /// 검색화면으로 이동하기 위한 메서드다. 
    func showSearchViewController() {
        let searchViewController: SearchViewController = SearchViewController()
        searchViewController.coordinator = self
        navigationController.pushViewController(searchViewController, animated: true)
    }
    
    /// 현재 뷰컨트롤러를 걷어내어 뒤로 이동한다. 
    func back() {
        navigationController.popViewController(animated: true)
    }
    
    /// 설정화면으로 이동하기 위한 메서드다
    func showSettingViewController() {
        let settingCoordinator: SettingCoordinator = SettingCoordinator(navigationController: navigationController)
        settingCoordinator.start()
    }
}

extension EasyLookCoordinator: PostCoordinatorProtocol {
    func showPostViewController(with viewModel: PostViewModel) {
        // TODO: - ⚠️ PostViewController로 대체할 예정
        navigationController.pushViewController(TestPostViewController(postViewModel: viewModel), animated: true)
    }
}
