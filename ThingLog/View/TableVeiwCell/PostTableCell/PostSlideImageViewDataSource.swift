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
        guard let cell: ZoomableCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ZoomableCollectionCell.reuseIdentifier, for: indexPath) as? ZoomableCollectionCell else {
            return ZoomableCollectionCell()
        }

        cell.imageView.image = images[indexPath.item]

        return cell
    }
}
