//
//  PostSlideImageViewDataSource.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import UIKit

final class SlideImageViewDataSource: NSObject {
}

extension SlideImageViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ContentsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsCollectionViewCell else {
            return ContentsCollectionViewCell()
        }

        cell.imageView.image = UIImage(systemName: "square.and.arrow.up")

        return cell
    }
}
