//
//  SearchResultsViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/04.
//
import CoreData
import UIKit

/// 검색홈에서 검색결과에 CollectionView형태로 보여주는 Controller다.
class SearchResultsViewController: UIViewController {
    let collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: ResultCollectionSection.resultsCollectionViewLayout())
        collectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        collectionView.register(ContentsDetailCollectionViewCell.self, forCellWithReuseIdentifier: ContentsDetailCollectionViewCell.reuseIdentifier)
        collectionView.register(LeftLabelRightButtonHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: LeftLabelRightButtonHeaderView.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var totalFilterView: ResultsWithDropBoxView = {
        let view: ResultsWithDropBoxView = ResultsWithDropBoxView(superView: view)
        view.updateResultTotalLabel(by: "검색결과 " + "15" + "건")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// 섹션 - 모두보기 탭시 나타나는 CollectionViewController로, 현재 선택된 CollectionViewController가 나타난다.
    private var selectedCollectionViewController: BaseContentsCollectionViewController? {
        didSet {
            selectedCollectionViewController?.completionBlock = { [weak self] postCount in
                self?.selectedCollectionViewController?.resultsFilterView.updateResultTotalLabel(by: "\(postCount)건")
            }
        }
    }
    
    // 셀들의 데이터를 제공하는 ViewModel
    var viewModel: SearchResultsViewModel = SearchResultsViewModel()
    
    private let totalFilterViewHeight: CGFloat = 44.0
    
    // 모두보기 눌러서 allContentsViewContorller가 보여지고 있는지 확인하는 프로퍼티
    var isAllContentsShowing: Bool = false {
        didSet {
            showGridCollectionView(isAllContentsShowing)
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTotalFilterView()
        setupCollectionView()
        setupBackgroundColor()
    }
    
    // MARK: - Setup
    
    private func setupBackgroundColor() {
        collectionView.backgroundColor = SwiftGenColors.primaryBackground.color
    }
    
    private func setupTotalFilterView() {
        view.addSubview(totalFilterView)
        NSLayoutConstraint.activate([
            totalFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            totalFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            totalFilterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            totalFilterView.heightAnchor.constraint(equalToConstant: totalFilterViewHeight)
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: totalFilterView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.dataSource = self
    }
    
    /// 모두보기 버튼 탭시 나타날 여부를 결정한다.
    /// - Parameter bool: 나타나자고자 할 때 true를, 그렇지 않다면 false를 넣는다.
    private func showGridCollectionView(_ bool: Bool) {
        if bool {
            guard let viewController: BaseContentsCollectionViewController = selectedCollectionViewController else { return }
            addChild(viewController)
            let allView: UIView = viewController.view
            allView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(allView)
            NSLayoutConstraint.activate([
                allView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                allView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                allView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                allView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            selectedCollectionViewController?.removeFromParent()
            selectedCollectionViewController?.view.removeFromSuperview()
        }
    }
}

extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        ResultCollectionSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 글내용의 경우 최대 3개만 보여주도록 한다.
        if section == ResultCollectionSection.postContents.section {
            let count: Int = viewModel.fetchedResultsControllers[section].fetchedObjects?.count ?? 0
            return min(count, 3)
        }
        return viewModel.fetchedResultsControllers[section].fetchedObjects?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 글 내용
        if ResultCollectionSection.postContents.section == indexPath.section {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsDetailCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsDetailCollectionViewCell else {
                return UICollectionViewCell()
            }
            let post: PostEntity? = viewModel.fetchedResultsControllers[indexPath.section].fetchedObjects?[indexPath.item]
            cell.updateView(post: post, keyWord: viewModel.keyWord)
            return cell
            
            // 그외 ( 카테고리, 물건이름, 선물받은, 거래처/판매처 )
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsCollectionViewCell else { return UICollectionViewCell() }
            cell.backgroundColor = SwiftGenColors.gray5.color
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == ResultCollectionSection.sectionHeaderKind {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LeftLabelRightButtonHeaderView.reuseIdentifier, for: indexPath) as? LeftLabelRightButtonHeaderView else {
                return UICollectionReusableView()
            }
            
            let section: ResultCollectionSection? = ResultCollectionSection.init(rawValue: indexPath.section)
            let fetchedResultsControllers: NSFetchedResultsController<PostEntity> = viewModel.fetchedResultsControllers[indexPath.section]
            let headerTitle: String? = section?.headerTitle
            let postCount: Int = fetchedResultsControllers.fetchedObjects?.count ?? 0
            
            // HeaderView 업데이트
            headerView.updateTitle(title: headerTitle,
                                   subTitle: "\(postCount) 건")
            if (section == .postContents && postCount <= 3) || postCount == 0 {
                headerView.rightButton.isHidden = true
            } else {
                headerView.rightButton.isHidden = false
            }
            
            // 모두보기 선택시, 글내용인 경우만 PostContentsCollectionViewController를 보여준다.
            headerView.rightButton.rx.tap
                .bind { [weak self] in
                    self?.isAllContentsShowing = false
                    // 섹션 타입으로 특정 Controller로 초기화하고
                    if section == .postContents {
                        let postController: PostContentsCollectionViewController = PostContentsCollectionViewController(willHideFilterView: false)
                        postController.keyWord = self?.viewModel.keyWord
                        self?.selectedCollectionViewController = postController
                    } else {
                        self?.selectedCollectionViewController = BaseContentsCollectionViewController(willHideFilterView: false)
                    }
                    
                    // 해당 controller에 resultsController를 주입한다.
                    self?.selectedCollectionViewController?.fetchResultController = fetchedResultsControllers
                    
                    self?.isAllContentsShowing = true
                    
                    // 해당 controller의 filterView를 업데이트 한다.
                    self?.selectedCollectionViewController?.resultsFilterView.updateTitleLabel(by: headerTitle)
                    self?.selectedCollectionViewController?.resultsFilterView.updateResultTotalLabel(by: "\(postCount)건")
                }
                .disposed(by: headerView.disposeBag)
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}
