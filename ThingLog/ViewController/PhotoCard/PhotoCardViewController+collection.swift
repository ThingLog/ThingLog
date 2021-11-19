//
//  PhotoCardViewController+collection.swift
//  ThingLog
//
//  Created by hyunsu on 2021/11/17.
//
import UIKit

extension PhotoCardViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollectionView {
            return photoCardViewModel.colorList.count
        } else {
            return photoCardViewModel.smallFrameList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewWithSelectViewCollectionCell.reuseIdentifier, for: indexPath) as? ImageViewWithSelectViewCollectionCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = SwiftGenColors.primaryBackground.color
        if collectionView == colorCollectionView {
            cell.tint(photoCardViewModel.selectColorIndex == indexPath.item)
            cell.changeImageViewBackgroundColor(photoCardViewModel.colorList[indexPath.item])
            if indexPath.item == 0 {
                cell.setImageViewLayerBorderWithWhiteColor(true)
            } else if indexPath.item == photoCardViewModel.colorList.count - 1 {
                cell.setImageViewLayerBorderWithBlackColor(true)
            } else {
                cell.setImageViewLayerBorderWithBlackColor(false)
            }
            cell.changeLayerCornerRadius(imageRadius: (inset.heightForCollectionView - 16) / 2,
                                         selectRadius: (inset.heightForCollectionView) / 2)
            return cell
        } else {
            cell.tint(photoCardViewModel.selectFrameIndex == indexPath.item)
            cell.changeImageView(photoCardViewModel.smallFrameList[indexPath.item])
            if indexPath.item == photoCardViewModel.colorList.count - 1 {
                cell.setImageViewLayerBorderWithBlackColor(true)
            } else {
                cell.setImageViewLayerBorderWithBlackColor(false)
            }
            cell.changeLayerCornerRadius(imageRadius: 4.5,
                                         selectRadius: 3.5)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorCollectionView {
            photoCardViewModel.selectColorIndex = indexPath.item
            collectionView.reloadData()
        } else {
            photoCardViewModel.selectFrameIndex = indexPath.item
            collectionView.reloadData()
        }
    }
}
