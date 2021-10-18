//
//  ResultCollectionSection.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/04.
//

import UIKit

/// 검색화면 - 검색결과에 따른 CollectionView로 보여줄 때 각 섹션에 해당하는 데이터를 추상화한 Enum 타입이다.
enum ResultCollectionSection: Int, CaseIterable {
    case category = 0
    case postTitle = 1
    case postContents = 2
    case gift = 3
    case place = 4
    
    var section: Int {
        self.rawValue
    }
    
    var headerTitle: String {
        switch self {
        case .category:
            return "카테고리"
        case .postTitle:
            return "물건이름"
        case .postContents:
            return "글 내용"
        case .gift:
            return "선물 준 사람"
        case .place:
            return "구매처/판매처"
        }
    }
    
    static var sectionHeaderKind: String {
        "header"
    }
    
    static func resultsCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex: Int, _ : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let isPostContentsSection: Bool = sectionIndex == ResultCollectionSection.postContents.section
            
            let groupHeight: NSCollectionLayoutDimension = isPostContentsSection ? .estimated(1) :  .estimated(1)
            let groupWidth: NSCollectionLayoutDimension = isPostContentsSection ? .fractionalWidth(1.0) : .absolute(124)

            let itemWidth: NSCollectionLayoutDimension = isPostContentsSection ? .fractionalWidth(1.0) : .estimated(1.0)
            let itemHeight: NSCollectionLayoutDimension = isPostContentsSection ? .absolute(110) : .estimated(1.0)
            
            let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: itemHeight)

            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: groupWidth, heightDimension: groupHeight)
            
            var group: NSCollectionLayoutGroup
            if isPostContentsSection {
                group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            } else {
                group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            }
            
            let header: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44)), elementKind: ResultCollectionSection.sectionHeaderKind, alignment: .topLeading)
            let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = isPostContentsSection ? .none : .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
            section.interGroupSpacing = isPostContentsSection ? 16.0 : 1
            section.boundarySupplementaryItems = [header]
            
            return section
        }
        return layout
    }
}
