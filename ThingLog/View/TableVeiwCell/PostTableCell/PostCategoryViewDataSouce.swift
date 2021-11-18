//
//  PostCategoryViewDataSouce.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import UIKit

final class PostCategoryViewDataSouce: NSObject {
    var items: [String] = []
    var isEmpty: Bool = false
}

extension PostCategoryViewDataSouce: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: LabelWithButtonRoundCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelWithButtonRoundCollectionCell.reuseIdentifier, for: indexPath) as? LabelWithButtonRoundCollectionCell else {
            return LabelWithButtonRoundCollectionCell()
        }

        cell.configure(text: items[indexPath.item], buttonIsHidden: true)
        isEmpty ? cell.configureColor(SwiftGenColors.gray2.color) : cell.configureColor(SwiftGenColors.primaryBlack.color)

        return cell
    }
}
