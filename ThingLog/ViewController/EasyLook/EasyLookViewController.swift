//
//  EasyLookViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/20.
//
import RxSwift
import UIKit

final class EasyLookViewController: UIViewController {
    var coordinator: EasyLookCoordinator?
    
    // MARK: - View
    lazy var easyLookTopView: EasyLookTopView = {
        let easyLookTopView: EasyLookTopView = EasyLookTopView(superView: view)
        easyLookTopView.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(.required, for: .vertical)
        return easyLookTopView
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
        button.setImage(SwiftGenIcons.topButton.image, for: .normal)
        button.alpha = 0
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(clickTopButton), for: .touchUpInside)
        return button
    }()
    
    let contentsViewController: BaseContentsCollectionViewController = BaseContentsCollectionViewController(willHideFilterView: true)
    
    // MARK: - Properties
    var viewModel: EasyLookViewModel = EasyLookViewModel()
    let categoryRepo: CategoryRepository = CategoryRepository(fetchedResultsControllerDelegate: nil)
    
    var easyLookTopViewHeightConstriant: NSLayoutConstraint?
    var currentEasyLookTopViewHeight: CGFloat = 0
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundColor()
        setupNavigationBar()
        setupEasyLookTopView()
        setupContainerView()
        setupContentsController()
        setupTopButton()
        
        subscribeEasyLookTapView()
        subscribeResultsWithDropBoxView()
        subscribeHorizontalCollectionView()
        subscribeBaseControllerScrollOffset()
        subscribeContentViewControllerDidSelect()
        
        fetchAllPosts()
        fetchAllCategory()
        
        setupHorizontalColletionCompletion()
        setupContentsViewControllerCompletion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        easyLookTopView.horizontalCollectionView.reloadData()
    }
}

extension EasyLookViewController {
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
