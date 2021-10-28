//
//  PhotosViewController+CollectionView.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/28.
//

import UIKit
import Photos

// MARK: - UICollectionView DataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1 + assets.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsCollectionViewCell else {
            fatalError("Unable to dequeue PhotoCollectionViewCell")
        }

        // Camera Cell
        if indexPath.item == 0 {
            cell.update(image: SwiftGenAssets.camera.image)
            return cell
        }

        let asset: PHAsset = assets.object(at: indexPath.item - 1)

        cell.representedAssetIdentifier = asset.localIdentifier
        asset.toImage(targetSize: thumbnailSize) { image in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.update(image: image)
            }
        }
        
        cell.setupImageViewWithCheckButton()
        cell.updateCheckButton(string: "", backgroundColor: .clear)
        DispatchQueue.main.async {
            self.updateSelectedOrder()
        }

        return cell
    }
}

// MARK: - UIColelctionView Delegate
extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // TODO: 카메라 기능 구현
            return
        }

        guard let cell: ContentsCollectionViewCell = collectionView.cellForItem(at: indexPath) as? ContentsCollectionViewCell else {
            return
        }

        if let firstIndex: Int = selectedIndexPath.firstIndex(of: indexPath) {
            selectedIndexPath.remove(at: firstIndex)
            cell.updateCheckButton(string: "", backgroundColor: .clear)
        } else {
            if selectedIndexPath.count < selectedMaxCount {
                selectedIndexPath.append(indexPath)
            } else {
                showMaxSelectedAlert()
            }
        }
    }
}
