//
//  PostContentsCollectionViewController.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/07.
//
import UIKit

/// 검색결과 `글내용`의 모두보기 선택시 나타나는 뷰컨트롤러이다. CollectionView만 변경하여 서브클래싱했다.
class PostContentsCollectionViewController: BaseContentsCollectionViewController {
    // 글내용의 특정 키워드를 강조하기 위해 필요한 프로퍼티
    var keyWord: String?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 기존의 CollectionViewLayout을 변경한다.
    override func setupBaseCollectionView() {
        let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))

        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(110))
        
        let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        section.interGroupSpacing = 16.0
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(section: section))
        collectionView.register(ContentsDetailCollectionViewCell.self, forCellWithReuseIdentifier: ContentsDetailCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        self.collectionView = collectionView
        
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

extension PostContentsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 글 내용
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsDetailCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.updateView(post: fetchResultController?.fetchedObjects?[indexPath.item], keyWord: keyWord)
        return cell
    }
}
