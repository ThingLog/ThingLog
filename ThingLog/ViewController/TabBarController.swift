//
//  TabBarController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/20.
//

import UIKit

final class TabBarController: UITabBarController {
    let homeCoordinator: HomeCoordinator = HomeCoordinator(navigationController: UINavigationController())
    let categoryCoordinator: CategoryCoordinator = CategoryCoordinator(navigationController: UINavigationController())
    let emptyViewController: UIViewController = UIViewController()
    
    // MARK: - View
    let choiceView: ChoiceWritingView = ChoiceWritingView()
    let dimmedView: UIView = {
        let dimmed: UIView = UIView()
        dimmed.backgroundColor = .black.withAlphaComponent(0.0)
        dimmed.isUserInteractionEnabled = true
        return dimmed
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupWriteView()
        setupDimmedView()
    }
    
    // MARK: - Setup
    private func setupView() {
        delegate = self
        tabBar.tintColor = SwiftGenColors.black.color // tabbar button 틴트 컬러
        tabBar.barTintColor = SwiftGenColors.white.color // Tabbar background 컬러
        
        homeCoordinator.start()
        categoryCoordinator.start()
        
        // TODO: ✅ SwiftGen이용하여 이미지 변경
        let homeTabImage: UIImage = SwiftGenAssets.homeTab.image
        let categoryTabImage: UIImage = SwiftGenAssets.categoryTab.image
        let plusTabImage: UIImage = SwiftGenAssets.plusTab.image.withRenderingMode(.alwaysOriginal)
        
        let homeTabBar: UITabBarItem = UITabBarItem(title: nil, image: homeTabImage, selectedImage: nil)
        let categoryTabBar: UITabBarItem = UITabBarItem(title: nil, image: categoryTabImage, selectedImage: nil)
        let plusTabBar: UITabBarItem = UITabBarItem(title: nil, image: plusTabImage, selectedImage: nil)
        
        homeTabBar.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        plusTabBar.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        categoryTabBar.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        
        homeCoordinator.navigationController.tabBarItem = homeTabBar
        categoryCoordinator.navigationController.tabBarItem = categoryTabBar
        emptyViewController.tabBarItem = plusTabBar
        
        viewControllers = [homeCoordinator.navigationController,
                           emptyViewController,
                           categoryCoordinator.navigationController]
    }
    
    private func setupWriteView() {
        view.addSubview(choiceView)
        NSLayoutConstraint.activate([
            choiceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            choiceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            choiceView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0)
        ])
    }
    
    private func setupDimmedView() {
        dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchDimmedView)))
    }
    
    private func constraintDimmedView(to view: UIView ) {
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Action
extension TabBarController {
    /// 현재 선택된 viewController의 최상단에 dimmedView를 부착한다.
    func attachDimmedView(to view: UIView? ) {
        guard let view = view else { return }
        view.addSubview(dimmedView)
        constraintDimmedView(to: view)
        view.layoutIfNeeded()
    }
    
    /// ``WriteView``를 숨기거나 나타나도록 하면서 애니메이션을 추가한다.
    /// - Parameter hide: 숨기고자 하는 경우는 true, 나타나고자 하는 경우는 false 이다.
    private func hideWriteViewWithAnimate(_ hide: Bool ) {
        if hide {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.choiceView.hide(true)
                self.dimmedView.backgroundColor = .clear
                self.rotatePlusButton(isRecovery: true)
                self.view.layoutIfNeeded()
            } completion: { _  in
                if self.choiceView.isShowing { return }
                self.dimmedView.removeFromSuperview()
            }
        } else {
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.choiceView.hide(false)
                self.dimmedView.backgroundColor = .black.withAlphaComponent(0.6)
                self.rotatePlusButton(isRecovery: false)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func rotatePlusButton(isRecovery recovery: Bool ) {
        let imageView: UIImageView? = tabBar.subviews[2].subviews.first as? UIImageView
        imageView?.contentMode = .center
        imageView?.transform = recovery ? .identity : CGAffineTransform(rotationAngle: .pi / 4)
    }
    
    /// dimmedView를 터치했을 때, WriteView를 숨기도록 한다.
    @objc
    func touchDimmedView() {
        hideWriteViewWithAnimate(true)
    }
}

// MARK: - TabBar Delegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == emptyViewController {
            if choiceView.isShowing {
                hideWriteViewWithAnimate(true)
            } else {
                attachDimmedView(to: viewControllers?[selectedIndex].view)
                hideWriteViewWithAnimate(false)
            }
            return false
        } else {
            if choiceView.isShowing {
                attachDimmedView(to: viewController.view)
            }
            hideWriteViewWithAnimate(true)
            return true
        }
    }
}
