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
    
    var scrollOffsetYSubject: PublishSubject = PublishSubject<CGFloat>()
    var disposeBag: DisposeBag = DisposeBag()
    var recentScrollOffsetY: CGFloat = 0
    var originScrollContentsHeight: CGFloat = 0
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func setupBaseCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
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
        cell.backgroundColor = UIColor(white: 239.0 / 255.0, alpha: 1.0)
        return cell
    }
}

extension BaseContentsCollectionViewController: UIScrollViewDelegate, UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
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
