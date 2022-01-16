//
//  BaseContentsCollectionViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/09/21.
//

import CoreData
import RxSwift
import UIKit

class BaseContentsCollectionViewController: UIViewController {
    var collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 1
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 2) / 3, height: (UIScreen.main.bounds.width - 2) / 3)
        flowLayout.sectionHeadersPinToVisibleBounds = true
        let collection: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    // 검색결과 - 모두보기 버튼 클릭시, 상단에 필요한 FilterView다. 재사용하기 위해 추가했다. 필요하지 않는 경우에는 숨긴다.
    lazy var resultsFilterView: ResultsWithDropBoxView = {
        let view: ResultsWithDropBoxView = ResultsWithDropBoxView(superView: self.view)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Post가 없는 경우에 보여주는 뷰다
    var emptyView: EmptyPostView = {
        let view: EmptyPostView = EmptyPostView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    // MARK: - Properties
    var fetchResultController: NSFetchedResultsController<PostEntity>? {
        didSet {
            fetchResultController?.delegate = self
        }
    }
    // CoreData가 외부에서 변경될 때 호출하는 클로저다
    var completionBlock: ((Int) -> Void)?
    /// 현재 스크롤하는 Y의 위치를 갖는 Subject다.
    var scrollOffsetYSubject: PublishSubject = PublishSubject<CGFloat>()
    /// 셀을 터치하는 경우에 발생되는 `PostViewModel`을 갖는 Subject다.
    var didSelectPostViewModelSubject: PublishSubject = PublishSubject<PostViewModel>()
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
        view.backgroundColor = SwiftGenColors.primaryBackground.color
        setupResultFilterView()
        setupBaseCollectionView()
        setupEmptyView()
        
        // 드롭박스가 가장 상단에 나타나야하기 때문에 collectionView 세팅 이후에 추가해야한다.
        resultsFilterView.updateDropBoxView(.total, superView: view)
        
        subscribeDropBox()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originScrollContentsHeight = collectionView.contentSize.height
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
        collectionView.backgroundColor = SwiftGenColors.primaryBackground.color
        collectionView.dataSource = self
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: resultsFilterView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// 드롭박스를 subscribe하여, 최신순/오래된 순인 경우에 fetchResultController의 sortDescriptor를 변경하여 다시 fetch한다.
    func subscribeDropBox() {
        resultsFilterView.stackView.arrangedSubviews.forEach {
            guard let dropBox: DropBoxView = $0 as? DropBoxView else {
                return
            }
            dropBox.selectFilterTypeSubject
                .subscribe( onNext: { [weak self] (value: (FilterType, String)) in
                    // ViewModel 변경
                    if value.0 == .latest {
                        self?.fetchResultController?.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createDate", ascending: !(value.1 == "최신순"))]
                        
                        do {
                            try self?.fetchResultController?.performFetch()
                            self?.collectionView.reloadData()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    func setupEmptyView() {
        view.addSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: resultsFilterView.bottomAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension BaseContentsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems: Int = fetchResultController?.fetchedObjects?.count ?? 0
        emptyView.isHidden = numberOfItems != 0
        return numberOfItems
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ContentsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath)as? ContentsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let item: PostEntity = fetchResultController?.fetchedObjects?[indexPath.item] {
            cell.updateView(item)
        }
        
        cell.backgroundColor = .clear
        return cell
    }
}

extension BaseContentsCollectionViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.reloadData()
        completionBlock?(controller.fetchedObjects?.count ?? 0)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let controller: NSFetchedResultsController = fetchResultController else {
            return
        }
        didSelectPostViewModelSubject.onNext(PostViewModel(fetchedResultsController: controller,
                                                           startIndexPath: indexPath))
    }
}
