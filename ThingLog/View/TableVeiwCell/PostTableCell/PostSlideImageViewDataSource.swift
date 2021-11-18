//
//  PostSlideImageViewDataSource.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import UIKit

final class PostSlideImageViewDataSource: NSObject {
    var images: [UIImage] = []
}

extension PostSlideImageViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ContentsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsCollectionViewCell else {
            return ContentsCollectionViewCell()
        }

        cell.imageView.image = images[indexPath.item]
        cell.setupDisplayOnlyImageView()

        return cell
    }
}
