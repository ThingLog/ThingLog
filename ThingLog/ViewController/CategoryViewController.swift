//
//  CategoryViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/20.
//
import RxSwift
import UIKit

final class CategoryViewController: UIViewController {
    var coordinator: Coordinator?
    
    lazy var categoryView: CategoryView = {
        let categoryView: CategoryView = CategoryView(superView: view)
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return categoryView
    }()
    
    // 게시물들을 보여주는 CollectioView가 담길 View이다.
    var contentsContainerView: UIView = {
        let view: UIView = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }()
    
    // 아래로 스크롤 할 시 나타나는 버튼으로, 누르면 최상단으로 스크롤해주는 기능을 가지는 Button이다.
    var topButton: UIButton = {
        let button: UIButton = UIButton()
        button.setImage(SwiftGenAssets.chevronUp.image, for: .normal)
        button.backgroundColor = SwiftGenColors.white.color
        button.alpha = 0
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickTopButton), for: .touchUpInside)
        return button
    }()
    
    let contentsViewController: BaseContentsCollectionViewController = BaseContentsCollectionViewController()
    
    var viewModel: CategoryViewModel = CategoryViewModel()
    
    var categoryViewHeightConstriant: NSLayoutConstraint?
    var currentCategoryHeight: CGFloat = 0
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color
        setupNavigationBar()
        setupCategoryView()
        setupContainerView()
        setupContentsController()
        setupTopButton()
        
        subscribeCategoryView()
        subscribeCategoryFilterView()
        subscribeHorizontalCollectionView()
        subscribeBaseControllerScrollOffset()
    }
    
    // MARK: - Setup
    func setupCategoryView() {
        view.addSubview(categoryView)
        let safeLayoutGuide: UILayoutGuide = view.safeAreaLayoutGuide
        categoryViewHeightConstriant = categoryView.heightAnchor.constraint(equalToConstant: categoryView.normalHeight)
        self.currentCategoryHeight = categoryView.normalHeight
        categoryViewHeightConstriant?.isActive = true
        NSLayoutConstraint.activate([
            categoryView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            categoryView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor)
        ])
    }
    
    func setupTopButton() {
        view.addSubview(topButton)
        let safeLayoutGuide: UILayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            topButton.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -26),
            topButton.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -29),
            topButton.widthAnchor.constraint(equalToConstant: 44),
            topButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        topButton.layer.cornerRadius = 22
        topButton.clipsToBounds = true
    }
    
    func setupContainerView() {
        view.addSubview(contentsContainerView)
        NSLayoutConstraint.activate([
            contentsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentsContainerView.topAnchor.constraint(equalTo: categoryView.bottomAnchor),
            contentsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupContentsController() {
        addChild(contentsViewController)
        contentsViewController.setupBaseCollectionView()
        
        contentsContainerView.addSubview(contentsViewController.view)
        let contentsView: UIView = contentsViewController.view
        contentsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentsView.leadingAnchor.constraint(equalTo: contentsContainerView.leadingAnchor),
            contentsView.trailingAnchor.constraint(equalTo: contentsContainerView.trailingAnchor),
            contentsView.topAnchor.constraint(equalTo: contentsContainerView.topAnchor),
            contentsView.bottomAnchor.constraint(equalTo: contentsContainerView.bottomAnchor)
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
        
        let logoView: LogoView = LogoView("모아보기")
        let logoBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: logoView)
        navigationItem.leftBarButtonItem = logoBarButtonItem
        
        let searchButton: UIButton = UIButton()
        searchButton.setImage(SwiftGenAssets.search.image, for: .normal)
        searchButton.tintColor = SwiftGenColors.black.color
        
        let settingButton: UIButton = UIButton()
        settingButton.setImage(SwiftGenAssets.setting.image, for: .normal)
        settingButton.tintColor = SwiftGenColors.black.color
        // settingButton.addTarget(self, action: #selector(showSettingView), for: .touchUpInside)
        let settingBarButton: UIBarButtonItem = UIBarButtonItem(customView: settingButton)
        let searchBarButton: UIBarButtonItem = UIBarButtonItem(customView: searchButton)
        let spacingBarButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacingBarButton.width = 24
        navigationItem.rightBarButtonItems = [settingBarButton, spacingBarButton, searchBarButton]
    }
}

extension CategoryViewController {
    /// CategoryView의 액션에 맞게 원하는 결과값이 담기는지 확인하기 위한 메서드다. 이것이 성공한다면 각 조합에 맞는 fetchRequest가 정상적으로 호출할 수 있다.
    func testViewModel() {
        print(viewModel.currentTopCategoryType)
        print(viewModel.currentSubCategoryType)
        print(viewModel.currentFilterType)
        print()
    }
    
    /// 드롭박스를 탭할 경우를 subscribe한다.
    func subscribeCategoryFilterView() {
        categoryView.categoryFilterView.stackView.arrangedSubviews.forEach {
            guard let dropBox: DropBoxView = $0 as? DropBoxView else {
                return
            }
            dropBox.selectFilterTypeSubject
                .subscribe( onNext: { [weak self] (value: (FilterType, String)) in
                    // ViewModel 변경
                    self?.viewModel.changeCurrentFilterType(type: value.0, value: value.1)
                    self?.testViewModel()
                })
                .disposed(by: disposeBag)
        }
    }
    
    /// "카테고리"의 sub Category를 선택하는 경우를 subscribe한다.
    func subscribeHorizontalCollectionView() {
        categoryView.horizontalCollectionView.categoryTitleSubject
            .subscribe( onNext: { [weak self] titleCategory in
                self?.viewModel.currentSubCategoryType = titleCategory
                self?.testViewModel()
            })
            .disposed(by: disposeBag)
    }
    
    /// 최상단 CategoryTab에서 특정 카테고리를 탭할 경우를 subscribe한다.
    func subscribeCategoryView() {
        categoryView.categoryTapView.topCategoryTypeSubject
            .subscribe(onNext: { [weak self] type in
                // 1. ViewModel 변경
                self?.viewModel.currentTopCategoryType = type
                
                // 2. HorizontalCollectionView 애니메이션
                UIView.animate(withDuration: 0.2) {
                    self?.categoryViewHeightConstriant?.constant = type == .category ? self?.categoryView.maxHeight ?? 0 : self?.categoryView.normalHeight ?? 0
                    self?.currentCategoryHeight = type == .category ? self?.categoryView.maxHeight ?? 0 : self?.categoryView.normalHeight ?? 0
                    
                    self?.view.layoutIfNeeded()
                }
                
                // 3. DropBox 변경
                self?.categoryView.categoryFilterView.updateDropBoxView(type, superView: self?.view ?? UIView() )
                
                // 4. DropBox가 전부 변경되므로 subscribe한다.
                self?.subscribeCategoryFilterView()
                
                // 5. HorizontalCollectionView 데이터 변경
                if type == .category {
                    // TODO: - ⚠️CoreData를 이용하여 가져올 예정이다.
                    self?.categoryView.horizontalCollectionView.categoryList = [
                        "학용품", "다이어리", "학용품", "다이어리", "학용품", "다이어리", "학용품", "다이어리",
                        "학용품", "다이어리", "학용품", "다이어리", "학용품", "다이어리", "학용품", "다이어리"
                    ]
                    self?.categoryView.horizontalCollectionView.isCollapse = false
                    self?.categoryView.horizontalCollectionView.reloadData()
                }
                
                self?.testViewModel()
            })
            .disposed(by: disposeBag)
    }
    
    /// CollectionView 스크롤을 subscribe 하여 상단 탭을 애니메이션 한다.
    func subscribeBaseControllerScrollOffset() {
        contentsViewController.scrollOffsetYSubject
            .subscribe(onNext: { [weak self] dist in
                if dist >= 0 {
                    self?.categoryView.horizontalCollectionView.isCollapse = true
                    self?.view.layoutIfNeeded()
                } else if self?.categoryViewHeightConstriant?.constant == self?.categoryView.maxHeight {
                    self?.categoryView.horizontalCollectionView.isCollapse = false
                    self?.view.layoutIfNeeded()
                }
                
                guard let currentConstant = self?.categoryViewHeightConstriant?.constant else { return }
                var dist: CGFloat = dist
                
                // 카테고리 사라질 때
                if dist >= 0 {
                    dist = max(currentConstant - dist, 0)
                } else {
                    // 카테고리 나타날 때
                    dist = min(currentConstant - dist, self?.currentCategoryHeight ?? 0)
                    self?.showTopButton(false)
                }
                
                if dist <= 1 {
                    self?.showTopButton(true)
                }
                
                self?.categoryViewHeightConstriant?.constant = dist
            })
            .disposed(by: disposeBag)
    }
}

extension CategoryViewController {
    @objc
    func clickTopButton() {
        self.contentsViewController.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        showTopButton(true)
    }
    
    private func showTopButton(_ bool: Bool) {
        self.topButton.isHidden = !bool
        self.topButton.alpha = bool ? 1 : 0
    }
}
