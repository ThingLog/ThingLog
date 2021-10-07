//
//  CategoryViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/20.
//
import RxSwift
import UIKit

final class CategoryViewController: UIViewController {
    var coordinator: CategoryCoordinator?
    
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
    
    let contentsViewController: BaseContentsCollectionViewController = BaseContentsCollectionViewController(willHideFilterView: true)
    
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
}

extension CategoryViewController {
    @objc
    func clickTopButton() {
        self.contentsViewController.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        showTopButton(true)
    }
    
    func showTopButton(_ bool: Bool) {
        self.topButton.isHidden = !bool
        self.topButton.alpha = bool ? 1 : 0
    }
}
