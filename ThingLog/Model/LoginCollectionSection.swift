//
//  LoginCollectionSection.swift
//  ThingLog
//
//  Created by hyunsu on 2021/10/19.
//
import UIKit

/// 로그인화면 또는 프로필 편집화면에 사용되는 CollectionView의 Section모델이다.
enum LoginCollectionSection: Int, CaseIterable {
    case topPadding
    case userName // 닉네임
    case userOneLine // 한 줄 소개
    case recommand // 추천 소개 글
    case bottomPadding
    
    var section: Int {
        self.rawValue
    }
    
    static func resultsCollectionViewLayout(_ isLogin: Bool) -> UICollectionViewCompositionalLayout {
        let layout: UICollectionViewCompositionalLayout = UICollectionViewCompositionalLayout { (sectionIndex: Int, _ : NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let (itemSize, groupSize): (NSCollectionLayoutSize, NSCollectionLayoutSize) = size(by: sectionIndex)
            let group: NSCollectionLayoutGroup = group(by: sectionIndex,
                                                       itemSize: itemSize,
                                                       groupSize: groupSize)
            return section(sectionIndex: sectionIndex, group: group, isLogin: isLogin)
        }
        return layout
    }
}

extension LoginCollectionSection {
    private static func size(by sectionIndex: Int) -> (NSCollectionLayoutSize, NSCollectionLayoutSize) {
        var itemSize: NSCollectionLayoutSize =
            NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                   heightDimension: .fractionalHeight(1.0))
        var groupSize: NSCollectionLayoutSize
        switch sectionIndex {
        case LoginCollectionSection.userName.section,
             LoginCollectionSection.userOneLine.section:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(44))
        case LoginCollectionSection.recommand.section:
            itemSize = NSCollectionLayoutSize(widthDimension: .estimated(10),
                                              heightDimension: .fractionalHeight(1.0))
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(30.0))
        default:
            groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(1))
        }
        return (itemSize, groupSize)
    }
    
    private static func group(by sectionIndex: Int,
                              itemSize: NSCollectionLayoutSize,
                              groupSize: NSCollectionLayoutSize) -> (NSCollectionLayoutGroup) {
        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        var group: NSCollectionLayoutGroup
        switch sectionIndex {
        case LoginCollectionSection.recommand.section:
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(14)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        default:
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        }
        return group
    }
    
    private static func section(sectionIndex: Int, group: NSCollectionLayoutGroup, isLogin: Bool) -> NSCollectionLayoutSection {
        let loginHeader: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(60 + 120)), elementKind: LoginTopHeaderView.reuseIdentifier, alignment: .top)
        
        let emptyFooter: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: sectionIndex == LoginCollectionSection.bottomPadding.section ? .absolute(500) : .absolute(44)), elementKind: UICollectionReusableView.reuseIdentifier, alignment: .bottom)
        
        let recommendHeader: NSCollectionLayoutBoundarySupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50)), elementKind: LeftLabelRightButtonHeaderView.reuseIdentifier, alignment: .top)
        let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group)
        
        switch sectionIndex {
        case LoginCollectionSection.topPadding.section:
            section.boundarySupplementaryItems = isLogin ? [loginHeader, emptyFooter] : [emptyFooter]
        case LoginCollectionSection.recommand.section:
            section.boundarySupplementaryItems = [recommendHeader, emptyFooter]
            section.interGroupSpacing = 14
        default: // userName, userOneLine, bottomPadding
            section.boundarySupplementaryItems = [emptyFooter]
        }
        return section
    }
}
