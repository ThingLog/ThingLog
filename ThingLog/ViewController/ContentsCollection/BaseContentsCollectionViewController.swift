//
//  BaseContentsCollectionViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import RxSwift
import UIKit

class BaseContentsCollectionViewController: UIViewController {
    var collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 2 ) / 3, height: (UIScreen.main.bounds.width - 2 ) / 3)
        flowLayout.sectionHeadersPinToVisibleBounds = true
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // 검색결과 - 모두보기 버튼 클릭시, 상단에 필요한 FilterView다. 재사용하기 위해 추가했다. 필요하지 않는 경우에는 숨긴다.
    lazy var resultsFilterView: CategoryFilterView = {
        let view: CategoryFilterView = CategoryFilterView(superView: self.view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var scrollOffsetYSubject: PublishSubject = PublishSubject<CGFloat>()
    var disposeBag: DisposeBag = DisposeBag()
    var recentScrollOffsetY: CGFloat = 0
    var originScrollContentsHeight: CGFloat = 0
    private var reusltFilterViewHeight: CGFloat = 44.0
    var resultFilterViewHeightConstraint: NSLayoutConstraint?
    
    /// 상단의 FilterView를 숨기거나 나타나게 한다. ( 필요하지 않은 경우에는 숨김처리한다. )
    /// - Parameter willHideFilterView: 숨기고자 하는 경우에 true , 그렇지 않은 경우에는 false
    init(willHideFilterView: Bool) {
        reusltFilterViewHeight = willHideFilterView ? 0 : 44.0
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SwiftGenColors.white.color
        setupResultFilterView()
        setupBaseCollectionView()
        
        // 드롭박스가 가장 상단에 나타나야하기 때문에 collectionView 세팅 이후에 추가해야한다. 
        resultsFilterView.updateDropBoxView(.total, superView: view)
    }
    
    func setupResultFilterView() {
        view.addSubview(resultsFilterView)
        resultFilterViewHeightConstraint = resultsFilterView.heightAnchor.constraint(equalToConstant: reusltFilterViewHeight)
        resultFilterViewHeightConstraint?.isActive = true
        NSLayoutConstraint.activate([
            resultsFilterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultsFilterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultsFilterView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    func setupBaseCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = SwiftGenColors.white.color
        collectionView.dataSource = self
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: resultsFilterView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension BaseContentsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        100
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ContentsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsCollectionViewCell else  { return UICollectionViewCell() }
        cell.backgroundColor = SwiftGenColors.gray6.color
        return cell
    }
}

extension BaseContentsCollectionViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= 0 {
            // 맨위에 스크롤한 경우
            scrollOffsetYSubject.onNext(-200)
            return
        } else if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.height {
            // 이미 맨 아래까지 스크롤한 경우
            return
        }
        let nextOffset: CGFloat = scrollView.contentOffset.y - recentScrollOffsetY
        
        if scrollView.contentSize.height > scrollView.frame.height && nextOffset > 0 {
            scrollOffsetYSubject.onNext(nextOffset)
        } else if scrollView.contentOffset.y <= scrollView.frame.height / 2 && nextOffset < 0 {
            // -> 내리기
            scrollOffsetYSubject.onNext(nextOffset)
        }
        recentScrollOffsetY = scrollView.contentOffset.y
    }
}
