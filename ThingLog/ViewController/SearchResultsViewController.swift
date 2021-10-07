//
//  SearchResultsViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/04.
//
import UIKit

/// 검색홈에서 검색결과에 CollectionView형태로 보여주는 Controller다.
class SearchResultsViewController: UIViewController {
    let collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: ResultCollectionSection.resultsCollectionViewLayout())
        collectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        collectionView.register(ContentsDetailCollectionViewCell.self, forCellWithReuseIdentifier: ContentsDetailCollectionViewCell.reuseIdentifier)
        collectionView.register(LeftLabelRightButtonHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: LeftLabelRightButtonHeaderView.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    lazy var totalFilterView: CategoryFilterView = {
        let view: CategoryFilterView = CategoryFilterView(superView: view)
        view.updateResultTotalLabel(by: "검색결과 " + "15" + "건")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// 섹션 - 모두보기 탭시 나타나는 CollectionViewController로, 현재 선택된 CollectionViewController가 나타난다.
    private var selectedCollectionViewController: BaseContentsCollectionViewController?
    
    // TODO: ⚠️ NSFetchResultsController가질 예정 
    private let totalFilterViewHeight: CGFloat = 44.0
    
    // 모두보기 눌러서 allContentsViewContorller가 보여지고 있는지 확인하는 프로퍼티
    var isAllCntentsShowing: Bool = false {
        didSet {
            showGridCollectionView(isAllCntentsShowing)
        }
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTotalFilterView()
        setupCollectionView()
    }
    
    // MARK: - Setup
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
        // Test
        if ResultCollectionSection.postContents.section == section {
            return 3
        }
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 글 내용
        if ResultCollectionSection.postContents.section == indexPath.section {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsDetailCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsDetailCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.updateView()
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
            let headerTitle: String? = section?.headerTitle
            headerView.updateTitle(title: headerTitle,
                                   subTitle: "10 건")
            
            // 모두보기 선택시, 글내용인 경우만 PostContentsCollectionViewController를 보여준다.
            headerView.rightButton.rx.tap
                .bind { [weak self] in
                    self?.isAllCntentsShowing = false
                    self?.selectedCollectionViewController = section == .postContents ? PostContentsCollectionViewController(willHideFilterView: false) : BaseContentsCollectionViewController(willHideFilterView: false)
                    self?.isAllCntentsShowing = true
                    self?.selectedCollectionViewController?.resultsFilterView.updateTitleLabel(by: headerTitle)
                    // TODO: ⚠️ 데이터 바인딩 하기
                }
                .disposed(by: headerView.disposeBag)
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}
