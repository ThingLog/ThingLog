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
    // MARK: - View
    let profileView: ProfileView = {
        let profileView: ProfileView = ProfileView()
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
    
    // MARK: - Properties
    
    var coordinator: HomeCoordinator?
    let userInformationViewModel: UserInformationViewModelable = UserInformationUserDefaultsViewModel()
    var drawerRespository: DrawerRepositoryable = DrawerCoreDataRepository(coreDataStack: CoreDataStack.shared)
    var heightAnchorProfileView: NSLayoutConstraint?
    let profileViewHeight: CGFloat = 3 + 80 + 11
    var willEnterForegroundObserver: NSObjectProtocol?
    
    var disposeBag: DisposeBag = DisposeBag()
    
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
        subscribeProfileEditButton()
        subscribeDrawerImageView()
        subscribeUserInformationChange()
        subscribeWillEnterForegroundNotification()
        
        fetchAllPost()
        fetchUserInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setDarkMode()
        fetchRepresentativeDrawer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(willEnterForegroundObserver)
    }
    
    // MARK: - Setup
    func setupView() {
        view.backgroundColor = SwiftGenColors.primaryBackground.color
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
            contentsTabView.heightAnchor.constraint(equalToConstant: 37)
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
        setupBaseNavigationBar()
        
        let logoView: LogoView = LogoView("띵로그")
        let logoBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: logoView)
        navigationItem.leftBarButtonItem = logoBarButtonItem
        
        let settingButton: UIButton = UIButton()
        settingButton.setImage(SwiftGenIcons.system.image.withRenderingMode(.alwaysTemplate), for: .normal)
        settingButton.tintColor = SwiftGenColors.primaryBlack.color
        settingButton.rx.tap
            .bind { [weak self] in
                self?.coordinator?.showSettingViewController()
            }
            .disposed(by: disposeBag)
        let settingBarButton: UIBarButtonItem = UIBarButtonItem(customView: settingButton)
        navigationItem.rightBarButtonItem = settingBarButton
    }
}

extension HomeViewController {
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
            baseController.fetchResultController = postRepo.fetchResultsController(by: .fromHome)
            baseController.collectionView.reloadData()
            
            // PageType으로 특정 탭 버튼을 찾아 업데이트한다.
            let pageTypeButton: UIButton = contentsTabView.pageTypeButton(by: pageType)
            let count: Int = baseController.fetchResultController?.fetchedObjects?.count ?? 0
            pageTypeButton.setTitle(String(count), for: .normal)
            
            baseController.completionBlock = { updatedFetchedCount in
                pageTypeButton.setTitle(String(updatedFetchedCount), for: .normal)
            }
            
            // 추가적으로, 셀을 선택했을 때 이벤트를 옵저빙하여, PostViewController로 전환하도록 한다.
            baseController.didSelectPostViewModelSubject.bind { [weak self] postViewModel in
                self?.coordinator?.showPostViewController(with: postViewModel)
            }.disposed(by: baseController.disposeBag)
        }
    }
    
    func fetchUserInformation() {
        userInformationViewModel.fetchUserInformation { [weak self] userInformation in
            self?.updateProfileView(by: userInformation)
        }
    }
    
    func fetchRepresentativeDrawer() {
        if let representative: Drawerable = drawerRespository.fetchRepresentative(),
           let imageData: Data = representative.imageData,
           let drawerImage: UIImage = UIImage(data: imageData) {
            profileView.updateBadgeView(image: drawerImage)
        } else {
            profileView.updateBadgeView(image: SwiftGenDrawerList.emptyRepresentative.image.withRenderingMode(.alwaysTemplate))
        }
        
        // 새로운 진열장 이벤트 발생했는지 확인.
        drawerRespository.isNewEvent { isNew in
            guard isNew == true else {
                self.profileView.newBadgeAnimationView.isHidden = true
                return
            }
            self.profileView.setupDarkModeForAnimation()
            DispatchQueue.main.async {
                self.profileView.newBadgeAnimationView.isHidden = false
                self.profileView.newBadgeAnimationView.play()
            }
        }
    }
}
