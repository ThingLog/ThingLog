//
//  TabBarController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/20.
//

import UIKit

import RxCocoa
import RxSwift

final class TabBarController: UITabBarController {
    let homeCoordinator: HomeCoordinator = HomeCoordinator(navigationController: UINavigationController())
    let easyLookCoordinator: EasyLookCoordinator = EasyLookCoordinator(navigationController: UINavigationController())
    let emptyViewController: UIViewController = UIViewController()
    private lazy var writeCoordinator: WriteCoordinator = {
        let coordinator: WriteCoordinator = .init(navigationController: UINavigationController(),
                                                  parentViewController: self)
        return coordinator
    }()
    
    // MARK: - View
    let choiceView: ChoiceWritingView = ChoiceWritingView()
    let dimmedView: UIView = {
        let dimmed: UIView = UIView()
        dimmed.backgroundColor = SwiftGenColors.dimmedColor.color.withAlphaComponent(0.0)
        dimmed.isUserInteractionEnabled = true
        return dimmed
    }()
    
    // MARK: - Properties
    private let disposeBag: DisposeBag = DisposeBag()
    private var isFirstOpen: Bool = true
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkMode()
        setupView()
        setupWriteView()
        setupDimmedView()
        bindWriteType()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstOpen == false { return }
        
        let alert: AlertViewController = .makeAlertWithoutTextField(title: "업데이트 안내",
                                                                    description: "버그를 고치고, 성능을 개선했어요\n지금 업데이트하고 즐겨보세요!",
                                                                    leftButtonTitle: "나중에",
                                                                    rightButtonTitle: "지금 업데이트")
        alert.leftButton.rx.tap.bind {
            alert.dismiss(animated: false, completion: nil)
        }.disposed(by: disposeBag)
        
        alert.rightButton.rx.tap.bind {
            print("app store go")
        }.disposed(by: disposeBag)

        present(alert, animated: false) { [weak self] in
            self?.isFirstOpen = false
        }
    }
    
    // MARK: - Setup
    private func setupView() {
        delegate = self
        tabBar.tintColor = SwiftGenColors.primaryBlack.color // tabbar button 틴트 컬러
        tabBar.unselectedItemTintColor = SwiftGenColors.systemRed.color // 이건 적용안됌 ( 아래로 해결 )
        let appearance: UITabBarAppearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.normal.iconColor = SwiftGenColors.primaryBlack.color // 이걸로 적용해야함.
        appearance.backgroundColor = SwiftGenColors.primaryBackground.color
        appearance.shadowColor = SwiftGenColors.gray4.color
        appearance.shadowImage = UIImage.colorForNavBar(color: SwiftGenColors.gray4.color)
        tabBar.standardAppearance = appearance
        
        homeCoordinator.start()
        easyLookCoordinator.start()
        
        let homeTabBar: UITabBarItem = UITabBarItem(title: nil,
                                                    image: SwiftGenIcons.homeStroke.image.withRenderingMode(.alwaysTemplate),
                                                    selectedImage: SwiftGenIcons.homeFill.image.withRenderingMode(.alwaysTemplate))
        let easyLookTabBar: UITabBarItem = UITabBarItem(title: nil,
                                                        image: SwiftGenIcons.gatherStroke.image.withRenderingMode(.alwaysTemplate),
                                                        selectedImage: SwiftGenIcons.gatherFill.image.withRenderingMode(.alwaysTemplate))
        let plusTabBar: UITabBarItem = UITabBarItem(title: nil,
                                                    image: SwiftGenIcons.writingHole.image.withRenderingMode(.alwaysTemplate),
                                                    selectedImage: nil)
        
        homeTabBar.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        plusTabBar.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        easyLookTabBar.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        
        homeCoordinator.navigationController.tabBarItem = homeTabBar
        easyLookCoordinator.navigationController.tabBarItem = easyLookTabBar
        emptyViewController.tabBarItem = plusTabBar
        
        viewControllers = [homeCoordinator.navigationController,
                           emptyViewController,
                           easyLookCoordinator.navigationController]
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
    
    private func constraintDimmedView(to view: UIView) {
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func bindWriteType() {
        choiceView.selectedWriteTypeSubject
            .bind { [weak self] type in
                guard let self = self else { return }
                self.touchDimmedView()
                let viewModel: WriteViewModel = WriteViewModel(pageType: type)
                self.writeCoordinator.showWriteViewController(with: viewModel)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Action
extension TabBarController {
    /// 현재 선택된 viewController의 최상단에 dimmedView를 부착한다.
    func attachDimmedView(to view: UIView?) {
        guard let view = view else { return }
        view.addSubview(dimmedView)
        constraintDimmedView(to: view)
        view.layoutIfNeeded()
    }
    
    /// ``WriteView``를 숨기거나 나타나도록 하면서 애니메이션을 추가한다.
    /// - Parameter hide: 숨기고자 하는 경우는 true, 나타나고자 하는 경우는 false 이다.
    private func hideWriteViewWithAnimate(_ hide: Bool) {
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
            // 다른 뷰컨트롤러에서 탭바를 숨긴다음에는 다시 홈화면으로 올 경우, 탭바가 가장 앞으로 나타나게 되고, 그와 관련한 constraint가 삭제되는 이슈 때문에 추가적으로 코드를 넣었다.
            view.bringSubviewToFront(choiceView)
            choiceView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 0).isActive = true
            view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.choiceView.hide(false)
                self.dimmedView.backgroundColor = SwiftGenColors.dimmedColor.color.withAlphaComponent(0.6)
                self.rotatePlusButton(isRecovery: false)
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func rotatePlusButton(isRecovery recovery: Bool) {
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

