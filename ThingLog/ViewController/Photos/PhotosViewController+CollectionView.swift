//
//  PhotosViewController+CollectionView.swift
//  ThingLog
//
//  Created by 이지원 on 2021/10/28.
//

import Photos
import UIKit

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
            cell.setupDisplayOnlyImageView()
            return cell
        }

        setupContentsCell(cell: cell, at: indexPath)

        return cell
    }

    private func setupContentsCell(cell: ContentsCollectionViewCell, at indexPath: IndexPath) {
        let asset: PHAsset = assets.object(at: indexPath.item - 1)

        cell.representedAssetIdentifier = asset.localIdentifier

        cell.imageRequestID = imageManager.requestImage(for: asset,
                                                        targetSize: thumbnailSize,
                                                        contentMode: .aspectFill,
                                                        options: nil) { image, _ in
            if indexPath.item == 0 { return }
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.update(image: image)
            }
        }

        cell.checkButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.tappedCheckButton(cell, at: indexPath)
            }.disposed(by: cell.disposeBag)
        cell.setupImageViewWithCheckButton()
        cell.updateCheckButton(string: "", backgroundColor: .clear)
        if let firstIndex: Int = selectedIndexPath.firstIndex(of: indexPath) {
            cell.updateCheckButton(string: "\(firstIndex + 1)", backgroundColor: .black)
        }
    }

    /// 체크 버튼 선택 시 호출할 메서드, selectedIndexPath에 추가/삭제 기능을 수행한다.
    /// - Parameters:
    ///   - cell: 업데이트 하기 위한 셀
    ///   - indexPath: 선택한 셀의 IndexPath
    private func tappedCheckButton(_ cell: ContentsCollectionViewCell, at indexPath: IndexPath) {
        if let firstIndex: Int = self.selectedIndexPath.firstIndex(of: indexPath) {
            selectedIndexPath.remove(at: firstIndex)
            DispatchQueue.main.async {
                cell.updateCheckButton(string: "", backgroundColor: .clear)
                cell.layoutIfNeeded()
            }
        } else {
            if selectedIndexPath.count < selectedMaxCount {
                selectedIndexPath.append(indexPath)
            } else {
                showMaxSelectedAlert()
            }
        }
    }
}

// MARK: - UIColelctionView Delegate
extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // TODO: 카메라 기능 구현
            return
        }
    }
}

extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        guard let allLayoutAttributes: [UICollectionViewLayoutAttributes] = collectionViewLayout.layoutAttributesForElements(in: rect) else {
            return []
        }
        return allLayoutAttributes.map { $0.indexPath }
    }
}

extension PhotosViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
}
