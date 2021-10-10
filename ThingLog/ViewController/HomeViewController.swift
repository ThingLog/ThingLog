//
//  HomeViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/22.
//
import RxCocoa
import RxSwift
import UIKit

final class HomeViewController: UIViewController {
    let profileView: ProfileView = {
        let profileView: ProfileView = ProfileView()
        profileView.backgroundColor = SwiftGenColors.white.color
        profileView.translatesAutoresizingMaskIntoConstraints = false
        return profileView
    }()
    
    var contentsContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var contentsTabView: ContentsTabView = {
        let view: ContentsTabView = ContentsTabView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let pageViewController: ContentsPageViewController = {
        let controller: ContentsPageViewController = ContentsPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        return controller
    }()
    
    var coordinator: Coordinator?
    var heightAnchorProfileView: NSLayoutConstraint?
    let profileViewHeight: CGFloat = 44 + 24 + 16
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupContainerView()
        setupContentsTabView()
        setupPageViewController()
        
        subscribePageVeiwControllerTransition()
        subscribeContentsTabButton()
        subscribePageViewControllerScrollOffset()
        
        fetchAllPost()
    }
    
    // MARK: - Setup
    func setupView() {
        view.backgroundColor = SwiftGenColors.white.color
        view.addSubview(profileView)
        heightAnchorProfileView = profileView.heightAnchor.constraint(equalToConstant: profileViewHeight)
        heightAnchorProfileView?.isActive = true
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    func setupContainerView() {
        view.addSubview(contentsContainerView)
        NSLayoutConstraint.activate([
            contentsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentsContainerView.topAnchor.constraint(equalTo: profileView.bottomAnchor),
            contentsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupContentsTabView() {
        contentsContainerView.addSubview(contentsTabView)
        NSLayoutConstraint.activate([
            contentsTabView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            contentsTabView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            contentsTabView.topAnchor.constraint(equalTo: contentsContainerView.safeAreaLayoutGuide.topAnchor),
            contentsTabView.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    func setupPageViewController() {
        addChild(pageViewController)
        contentsContainerView.addSubview(pageViewController.view)
        let pageView: UIView = pageViewController.view
        pageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            pageView.topAnchor.constraint(equalTo: contentsTabView.bottomAnchor),
            pageView.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor)
        ])
    }
    
    func setupNavigationBar() {
        if #available(iOS 15, *) {
            let appearance: UINavigationBarAppearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = SwiftGenColors.white.color
            appearance.shadowColor = .clear
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        } else {
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = SwiftGenColors.white.color
            navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        }
        
        let logoView: LogoView = LogoView("띵로그")
        let logoBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: logoView)
        navigationItem.leftBarButtonItem = logoBarButtonItem
        
        let settingButton: UIButton = UIButton()
        settingButton.setImage(SwiftGenAssets.setting.image, for: .normal)
        settingButton.tintColor = SwiftGenColors.black.color
        // settingButton.addTarget(self, action: #selector(showSettingView), for: .touchUpInside)
        let settingBarButton: UIBarButtonItem = UIBarButtonItem(customView: settingButton)
        navigationItem.rightBarButtonItem = settingBarButton
    }
}

// MARK: - Subscribe Rx
extension HomeViewController {
    /// PageViewController의 page가 전환될 시 subscribe하여 뷰 업데이트를 진행하는 메소드다.
    func subscribePageVeiwControllerTransition() {
        pageViewController.currentPageIndexSubject
            .subscribe(onNext: { [weak self] index in
                self?.contentsTabView.updateIndicatorBar(by: index)
                self?.contentsTabView.updateButtonTintColor(by: index)
                self?.changeContentsContainerHeight(viewController: self?.pageViewController.controllers[index] as? BaseContentsCollectionViewController)
            })
            .disposed(by: pageViewController.disposeBag)
    }
    
    /// ContentsTabButton을 subscribe하여 각 버튼을 누를 시 PageViewController의 page를 전환하는 메소드다.
    func subscribeContentsTabButton() {
        for index in 0..<contentsTabView.buttonStackView.arrangedSubviews.count {
            guard let button: UIButton = contentsTabView.buttonStackView.arrangedSubviews[index] as? UIButton else { return }
            button.rx.tap.bind { [weak self] in
                self?.contentsTabView.updateButtonTintColor(by: index)
                var direction: UIPageViewController.NavigationDirection = .forward
                let pageIndex: Int? = self?.pageViewController.currentPageIndex
                if index == 0 {
                    direction = .reverse
                } else if index == 1 {
                    if pageIndex == 2 {
                        direction = .reverse
                    }
                }
                guard let nextViewController: UIViewController = self?.pageViewController.controllers[index] else { return }
                self?.pageViewController.setViewControllers([nextViewController], direction: direction, animated: true, completion: { _ in
                    self?.changeContentsContainerHeight(viewController: nextViewController as? BaseContentsCollectionViewController)
                })
                self?.contentsTabView.updateIndicatorBar(by: index)
            }
            .disposed(by: contentsTabView.disposeBag)
        }
    }
    
    /// PageViewController의 scroll offset을 subscribe 하여 ContainerView 높이를 조절하는 메소드다.
    func subscribePageViewControllerScrollOffset() {
        pageViewController.currentScrollContentsOffsetYSubject
            .subscribe(onNext: { [weak self] dist in
                // 최상단으로 스크롤했을 때
                if dist == -200 {
                    self?.profileView.hideBadgeView(false)
                }
                UIView.animate(withDuration: 0.1) {
                    guard let currentConstant = self?.heightAnchorProfileView?.constant else { return }
                    var dist: CGFloat = dist
                    if dist >= 0 {
                        dist = max(currentConstant - dist, 0)
                        self?.profileView.hideBadgeView(true)
                    } else {
                        dist = min(currentConstant - dist, self?.profileViewHeight ?? 44 + 24 + 16)
                        if dist >= 44 {
                            self?.profileView.hideBadgeView(false)
                        }
                    }
                    self?.heightAnchorProfileView?.constant = dist
                }
            })
            .disposed(by: pageViewController.disposeBag)
    }
    
    /// 콘텐츠 개수가 많은 상황에서 아래로 스크롤한 상태에서 콘텐츠 개수가 적은 페이지로 전환할 시 containerView의 높이를 줄여주는 메소드다.
    /// - Parameter viewController: 콘텐츠가 적은 페이지의 controller를 넣는다.
    func changeContentsContainerHeight(viewController: BaseContentsCollectionViewController?) {
        guard let baseController = viewController else { return }
        DispatchQueue.main.async {
            if baseController.originScrollContentsHeight <= baseController.collectionView.frame.height {
                UIView.animate(withDuration: 0.1) {
                    self.contentsContainerView.layoutIfNeeded()
                } completion: { _ in
                    UIView.animate(withDuration: 0.3) {
                        self.heightAnchorProfileView?.constant = self.profileViewHeight
                        self.view.layoutIfNeeded()
                    } completion: { _ in
                        self.profileView.hideBadgeView(false)
                    }
                }
            }
        }
    }
    
    /// pageViewController의 각 타입에 따라 Post들을 가져온다.
    func fetchAllPost() {
        for idx in 0..<pageViewController.controllers.count {
            // PageViewController에 속한 뷰컨트롤러를 찾고, BaseContents로 캐스팅한다.
            let controller: UIViewController = pageViewController.controllers[idx]
            guard let baseController: BaseContentsCollectionViewController = controller as? BaseContentsCollectionViewController else {
                return
            }
            
            // idx로 PageType을 찾고, 그에 맞는 NSFetchResulstsController를 주입한다.
            let postRepo: PostRepository = PostRepository(fetchedResultsControllerDelegate: nil)
            guard let pageType = PageType(rawValue: Int16(idx)) else { return }
            postRepo.pageType = pageType
            baseController.fetchResultController = postRepo.fetchedResultsController
            baseController.collectionView.reloadData()
            
            // PageType으로 특정 탭 버튼을 찾아 업데이트한다.
            let pageTypeButton: UIButton = contentsTabView.pageTypeButton(by: pageType)
            let count: Int = postRepo.fetchedResultsController.fetchedObjects?.count ?? 0
            pageTypeButton.setTitle(String(count), for: .normal)
            
            baseController.completionBlock = { [weak self] updatedFetchedCount in
                pageTypeButton.setTitle(String(updatedFetchedCount), for: .normal)
            }
        }
    }
}
