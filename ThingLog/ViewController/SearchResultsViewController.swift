//
//  SearchResultsViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/04.
//
import UIKit

/// 검색홈에서 검색결과에 CollectionView형태로 보여주는 Controller다.
class SearchResultsViewController: UIViewController {
    var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: ResultCollectionSection.resultsCollectionViewLayout())
        collectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier)
        collectionView.register(ContentsDetailCollectionViewCell.self, forCellWithReuseIdentifier: ContentsDetailCollectionViewCell.reuseIdentifier)
        collectionView.register(LeftLabelRightButtonHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: LeftLabelRightButtonHeaderView.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // TODO: ⚠️ NSFetchResultsController가질 예정 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.dataSource = self
    }
}

extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        ResultCollectionSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Test
        if ResultCollectionSection.contents.section == section {
            return 3
        }
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 글 내용
        if ResultCollectionSection.contents.section == indexPath.section {
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
            
            headerView.updateTitle(title: ResultCollectionSection.init(rawValue: indexPath.section)?.headerTitle)
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}
