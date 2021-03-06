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
        if indexPath.item == 0 {
            guard let cell: CenterIconCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: CenterIconCollectionCell.reuseIdentifier, for: indexPath) as? CenterIconCollectionCell else {
                return CenterIconCollectionCell()
            }
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.reuseIdentifier, for: indexPath) as? ContentsCollectionViewCell else {
            fatalError("Unable to dequeue PhotoCollectionViewCell")
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
        
        cell.checkButton.rx.controlEvent(.touchUpInside)
            .bind { [weak self] in
                guard let self = self else { return }
                self.tappedCheckButton(cell, at: indexPath)
            }.disposed(by: cell.disposeBag)
        cell.setupImageViewWithCheckButton()
        cell.updateCheckButton(string: "")
        if let firstIndex: Int = selectedImages.firstIndex(where: {$0.indexPath == indexPath}) {
            cell.updateCheckButton(string: "\(firstIndex + 1)")
        }
    }
    
    /// 체크 버튼 선택 시 호출할 메서드, selectedIndexPath에 추가/삭제 기능을 수행한다.
    /// - Parameters:
    ///   - cell: 업데이트 하기 위한 셀
    ///   - indexPath: 선택한 셀의 IndexPath
    private func tappedCheckButton(_ cell: ContentsCollectionViewCell, at indexPath: IndexPath) {
        if let firstIndex: Int = selectedImages.firstIndex(where: {$0.indexPath == indexPath})  {
            selectedImages.remove(at: firstIndex)
            DispatchQueue.main.async {
                cell.updateCheckButton(string: "")
                cell.layoutIfNeeded()
            }
        } else {
            if selectedImages.count < selectedMaxCount {
                selectedImages.append(ImageEditInfo(indexPath: indexPath, image: nil))
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
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                present(imagePickerController, animated: true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    guard let self = self else { return }
                    if granted {
                        DispatchQueue.main.async {
                            self.present(self.imagePickerController, animated: true)
                        }
                    }
                }
            case .denied, .restricted:
                coordinator?.showMoveSettingAlert()
            @unknown default:
                coordinator?.showMoveSettingAlert()
            }
        } else {
            let asset: PHAsset = assets.object(at: indexPath.item - 1)
            let option: PHImageRequestOptions = PHImageRequestOptions()
            option.deliveryMode = .highQualityFormat
            
            imageManager.requestImage(for: asset,
                                      targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                                      contentMode: .aspectFill,
                                      options: option) { image, _ in
                guard let image: UIImage = image,
                      let cell: ContentsCollectionViewCell = collectionView.cellForItem(at: indexPath) as? ContentsCollectionViewCell else { return }
                DispatchQueue.main.async {
                    var imageInfo: ImageEditInfo
                    if let firstIndex: Int = self.selectedImages.firstIndex(where: { $0.indexPath == indexPath }) {
                        cell.updateCheckButton(string: "\(firstIndex + 1)")
                        imageInfo = self.selectedImages[firstIndex]
                        if imageInfo.image == nil {
                            imageInfo.image = image
                        }
                        self.showCropViewController(selectedImage: imageInfo)
                    } else {
                        if self.selectedImages.count < self.selectedMaxCount {
                            imageInfo = ImageEditInfo(indexPath: indexPath, image: image)
                            self.selectedImages.append(imageInfo)
                            cell.updateCheckButton(string: "\(self.selectedImages.count)")
                            self.showCropViewController(selectedImage: imageInfo)
                        } else {
                            self.showMaxSelectedAlert()
                        }
                    }
                }
            }
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
