//
//  PostCategoryViewDataSouce.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import UIKit

final class PostCategoryViewDataSouce: NSObject {
}

extension PostCategoryViewDataSouce: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: remove test data
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: LabelWithButtonRoundCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelWithButtonRoundCollectionCell.reuseIdentifier, for: indexPath) as? LabelWithButtonRoundCollectionCell else {
            return LabelWithButtonRoundCollectionCell()
        }

        cell.configure(text: "전자제품", buttonIsHidden: true)

        return cell
    }
}
