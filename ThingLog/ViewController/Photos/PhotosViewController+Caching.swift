//
//  PhotosViewController+Caching.swift
//  ThingLog
//
//  Created by 이지원 on 2021/11/02.
//

import Photos
import UIKit

// MARK: - Asset Caching
// Source: https://developer.apple.com/documentation/photokit/loading_and_caching_assets_and_thumbnails
extension PhotosViewController {
    func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }

    func updateCachedAssets() {
        // 뷰가 표시되고 있는 경우에만 Update
        guard isViewLoaded && view.window != nil else { return }

        // 미리 준비한 window는 표시되고 있는 높이의 두 배
        let visibleRect: CGRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let preheatRect: CGRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)

        // 보이는 영역이 마지막으로 예열된 영역과 크게 다른 경우에만 업데이트
        let delta: CGFloat = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }

        // 캐싱을 시작하고 정지할 assets 계산
        // indexPath.item이 0인 경우는 카메라 셀을 표시하므로 필터링
        let (addedRects, removedRects): ([CGRect], [CGRect]) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets: [PHAsset] = addedRects
            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
            .filter { indexPath in indexPath.item == 0 }
            .map { indexPath in assets.object(at: indexPath.item) }
        let removedAssets: [PHAsset] = removedRects
            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
            .filter { indexPath in indexPath.item == 0 }
            .map { indexPath in assets.object(at: indexPath.item) }

        // PHCachingImageManager가 캐싱한 자산을 업데이트
        imageManager.startCachingImages(for: addedAssets,
                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets,
                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        // 향후 비교를 위해 계산된 사각형을 저장
        previousPreheatRect = preheatRect
    }

    func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added: [CGRect] = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed: [CGRect] = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
}
